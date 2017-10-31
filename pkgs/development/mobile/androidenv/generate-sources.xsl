<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/repository/11">

  <xsl:output omit-xml-declaration="yes" indent="no" />

  <xsl:template name="repository-url">
    <xsl:variable name="raw-url" select="sdk:archives/sdk:archive/sdk:url"/>
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
# This file is generated from generate-sources.sh. DO NOT EDIT.
# Execute generate-sources.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildSource = args:
    stdenv.mkDerivation (args // {
      buildInputs = [ unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unzip $src
    '';
  });
in
{
<xsl:for-each select="sdk:source"><xsl:sort select="sdk:api-level" data-type="number"/>
  source_<xsl:value-of select="sdk:api-level" /> = buildSource {
    name = "android-source-<xsl:value-of select="sdk:api-level" />";
    src = fetchurl {
      url = <xsl:call-template name="repository-url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "Source code for Android API <xsl:value-of select="sdk:api-level" />";
    };
  };
</xsl:for-each>
}
</xsl:template>
</xsl:stylesheet>
