<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:sdk="http://schemas.android.com/sdk/android/repository/7">

  <xsl:output omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/sdk:sdk-repository">
{stdenv, fetchurl, unzip}:

let
  buildSystemImage = args:
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
    <xsl:for-each select="sdk:system-image">
  sysimg_<xsl:value-of select="sdk:api-level" /> = buildSystemImage {
    name = "<xsl:value-of select="sdk:abi" />-<xsl:value-of select="sdk:api-level" />";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive[@os='any']/sdk:url" />;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[@os='any']/sdk:checksum[@type='sha1']" />";
    };
  };
    </xsl:for-each>
}
  </xsl:template>

</xsl:stylesheet>
