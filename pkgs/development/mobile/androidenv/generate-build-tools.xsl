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
  <xsl:template name="revision">
    <xsl:param name="separator"/>
    <xsl:value-of select="sdk:revision/sdk:major"/>
    <xsl:if test="sdk:revision/sdk:minor &gt; 0 or sdk:revision/sdk:micro &gt; 0">
      <xsl:value-of select="$separator"/>
      <xsl:value-of select="sdk:revision/sdk:minor"/>
      <xsl:if test="sdk:revision/sdk:micro &gt; 0">
        <xsl:value-of select="$separator"/>
        <xsl:value-of select="sdk:revision/sdk:micro"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="sdk:revision/sdk:preview">
      <xsl:text>-rc</xsl:text>
      <xsl:value-of select="sdk:revision/sdk:preview"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/sdk:sdk-repository">
# This file is generated from generate-build-tools.sh. DO NOT EDIT.
# Execute generate-build-tools.sh or fetch.sh to update the file.
{stdenv, stdenv_32bit, fetchurl, unzip, zlib_32bit, ncurses_32bit, file, zlib, ncurses}@args:

let
  buildToolsFor = import ./build-tools.nix args;
in
{
<xsl:for-each select="sdk:build-tool">
  buildTools_<xsl:call-template name="revision"><xsl:with-param name="separator">_</xsl:with-param></xsl:call-template> = buildToolsFor rec {
    version = "<xsl:call-template name="revision"><xsl:with-param name="separator">.</xsl:with-param></xsl:call-template>";
    src = fetchurl {
      url = <xsl:call-template name="repository-url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[sdk:host-os=$os or count(sdk:host-os) = 0]/sdk:checksum[@type='sha1']" />";
    };
  };
</xsl:for-each>
}
</xsl:template>
</xsl:stylesheet>
