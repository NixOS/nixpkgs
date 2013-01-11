<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/repository/7">

  <xsl:param name="os" />
  <xsl:output omit-xml-declaration="yes" indent="no" />
  <xsl:template match="/sdk:sdk-repository">
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
    <xsl:for-each select="sdk:platform">
  platform_<xsl:value-of select="sdk:api-level" /> = buildPlatform {
    name = "android-platform-<xsl:value-of select="sdk:version" />";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive[@os=$os or @os='any']/sdk:url" />;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[@os=$os or @os='any']/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "<xsl:value-of select="sdk:description" />";
      <xsl:for-each select="sdk:desc-url">url = <xsl:value-of select="." />;</xsl:for-each>
    };
  };
    </xsl:for-each>
}
  </xsl:template>
</xsl:stylesheet>
