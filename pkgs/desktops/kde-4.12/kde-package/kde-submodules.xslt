<?xml version="1.0" encoding="UTF-8"?>
<!-- xslt file for http://projects.kde.org/kde_projects.xml -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" />
	<xsl:template match="/">
		<xsl:for-each select="kdeprojects/component[@identifier='kde']">
			<xsl:text>declare -A module</xsl:text>
			<xsl:for-each select="module">
				<xsl:variable name="module" select='@identifier' />
				<xsl:for-each select=".//project[repo]">
					<xsl:text>module["</xsl:text>
					<xsl:value-of select='@identifier' />
					<xsl:text>"]="</xsl:text>
					<xsl:value-of select="$module" />
					<xsl:text>"</xsl:text>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
