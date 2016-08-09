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
# This file is generated from generate-platforms.sh. DO NOT EDIT.
# Execute generate-platforms.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildPlatform = args:
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
    <xsl:for-each select="sdk:platform"><xsl:sort select="sdk:api-level" data-type="number"/>
  platform_<xsl:value-of select="sdk:api-level" /> = buildPlatform {
    name = "android-platform-<xsl:value-of select="sdk:version" />";
    src = fetchurl {
      url = <xsl:call-template name="repository-url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[sdk:host-os=$os or count(sdk:host-os) = 0]/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "<xsl:value-of select="sdk:description" />";
<xsl:for-each select="sdk:desc-url">      url = <xsl:value-of select="." />;</xsl:for-each>
    };
  };
</xsl:for-each>
}
</xsl:template>
</xsl:stylesheet>
