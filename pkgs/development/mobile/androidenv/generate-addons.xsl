<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/addon/5">

  <xsl:output omit-xml-declaration="yes" indent="no" />
  <xsl:template match="/sdk:sdk-addon">
{stdenv, fetchurl, unzip}:

let
  buildGoogleApis = args:
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
    <xsl:for-each select="sdk:add-on[sdk:name-id='google_apis']">
  google_apis_<xsl:value-of select="sdk:api-level" /> = buildGoogleApis {
    name = "<xsl:value-of select="sdk:name-id" />-<xsl:value-of select="sdk:api-level" />";
      src = fetchurl {
        url = https://dl-ssl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive[@os='any']/sdk:url" />;
        sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[@os='any']/sdk:checksum[@type='sha1']" />";
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
