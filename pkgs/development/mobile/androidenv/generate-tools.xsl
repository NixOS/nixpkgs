<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/repository/11">

  <xsl:param name="os" />
  <xsl:output omit-xml-declaration="yes" indent="no" />

  <xsl:template name="repository-url">
    <xsl:variable name="raw-url" select="sdk:archives/sdk:archive[sdk:host-os=$os or count(sdk:host-os) = 0]/sdk:url"/>
    <xsl:choose>
      <xsl:when test="starts-with($raw-url, 'http')">
        <xsl:value-of select="$raw-url"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>https://dl.google.com/android/repository/</xsl:text>
        <xsl:value-of select="$raw-url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/sdk:sdk-repository">
# This file is generated from generate-tools.sh. DO NOT EDIT.
# Execute generate-tools.sh or fetch.sh to update the file.
{ fetchurl }:

{
    <xsl:for-each select="sdk:build-tool">
      <xsl:sort select="sdk:revision/sdk:major" data-type="number"/>
      <xsl:sort select="sdk:revision/sdk:minor" data-type="number"/>
      <xsl:sort select="sdk:revision/sdk:micro" data-type="number"/>
      <xsl:sort select="sdk:revision/sdk:preview" data-type="number"/>
  v<xsl:value-of select="sdk:revision/sdk:major"/><xsl:if test="sdk:revision/sdk:minor + sdk:revision/sdk:micro > 0">_<xsl:value-of select="sdk:revision/sdk:minor" />_<xsl:value-of select="sdk:revision/sdk:micro"/></xsl:if><xsl:if test="sdk:revision/sdk:preview > 0">_rc<xsl:value-of select="sdk:revision/sdk:preview"/></xsl:if> = {
    version = "<xsl:value-of select="sdk:revision/sdk:major"/>.<xsl:value-of select="sdk:revision/sdk:minor" />.<xsl:value-of select="sdk:revision/sdk:micro"/><xsl:if test="sdk:revision/sdk:preview > 0">-rc<xsl:value-of select="sdk:revision/sdk:preview"/></xsl:if>";
    src = fetchurl {
      url = <xsl:call-template name="repository-url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[sdk:host-os=$os or count(sdk:host-os) = 0]/sdk:checksum[@type='sha1']" />";
    };
  };
</xsl:for-each>
}
</xsl:template>
</xsl:stylesheet>
