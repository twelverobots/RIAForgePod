<cfsetting enablecfoutputonly='true'>
<cfprocessingdirective pageencoding='utf-8'>
<!---
   Name : RiaForge
   Author : Jason Dean (http://ww.12robots.com)
   Created : July 8, 2011
--->

<cfmodule template="tags/scopecache.cfm" cachename="#application.applicationname#" scope="application" disabled="true" timeout="#application.timeout#">    

<cftry>
	<cfhttp url="http://www.riaforge.org/boltapi/api.cfc" result="allCFProjects">
		<cfhttpparam type="url" name="categoryid" value="1" />
		<cfhttpparam type="url" name="method" value="getProjects" />
		<cfhttpparam type="url" name="start" value="1" />
		<cfhttpparam type="url" name="page" value="250" />
		<cfhttpparam type="url" name="getitall" value="false" />
	</cfhttp>
	
	<cfwddx action="wddx2cfml" input="#allCFProjects.fileContent#" output="projectQuery" >
	
	<cfif 
		(NOT structKeyExists(APPLICATION, "projects") OR NOT structKeyExists(APPLICATION,"projectTimestamp"))
		OR
		(DateDiff("d", application.projectTimestamp, now()) GTE 1)	
		>
		
		<cfset application.projects = replace(valueList(projectQuery.id), ".0", "", "all") />
		<cfset application.projectTimestamp = now() />
		
	</cfif>
	
	<cfset randomProject = randRange(1, listLen(application.projects)) />
	
	<cfhttp url="http://www.riaforge.org/boltapi/api.cfc" result="CFProject">
		<cfhttpparam type="url" name="id" value="#randomProject#" />
		<cfhttpparam type="url" name="method" value="getProject" />
	</cfhttp>
	
	<cfwddx action="wddx2cfml" input="#CFProject.fileContent#" output="project" >
	
	<cfif project.recordcount neq 1>
		<cfthrow message="No Project" />
	</cfif>

	<cfset application.currentProject = project />
	
	<cfcatch type="any">
		<cfset application.currentProject = structNew() />
		<cfset application.currentProject.name = "BlogCFC" />
		<cfset application.currentProject.urlname = "blogcfc" />
		<cfset application.currentProject.shortdescription = "Awesome blogging software" />
	</cfcatch>
</cftry>

<cfmodule template="../../tags/podlayout.cfm" title="ColdFusion Project from RIAForge">
<cfoutput>
	<div style="padding-top:5px;">
	<a href="http://#application.currentProject.urlname#.riaforge.org"><strong>#application.currentProject.name#</strong></a>
	<p>#application.currentProject.shortdescription#</p>	
</cfoutput>
</div>
</cfmodule>






