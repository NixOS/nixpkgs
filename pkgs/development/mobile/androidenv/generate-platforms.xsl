<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/repository/10">

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
    <xsl:for-each select="sdk:platform[sdk:api-level &lt; 20]">
  platform_<xsl:value-of select="sdk:api-level" /> = buildPlatform {
    name = "android-platform-<xsl:value-of select="sdk:version" />";
    src = fetchurl {
      url = <xsl:value-of select="sdk:archives/sdk:archive[sdk:host-os=$os or count(sdk:host-os) = 0]/sdk:url" />;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[sdk:host-os=$os or count(sdk:host-os) = 0]/sdk:checksum[@type='sha1']" />";
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
