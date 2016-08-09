<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/addon/7">

  <xsl:output omit-xml-declaration="yes" indent="no" />
  <xsl:template match="/sdk:sdk-addon">
# This file is generated from generate-addons.sh. DO NOT EDIT.
# Execute generate-addons.sh or fetch.sh to update the file.
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
<xsl:for-each select="sdk:add-on[sdk:name-id='google_apis']"><xsl:sort select="sdk:api-level" data-type="number"/><xsl:sort select="sdk:revision" data-type="number"/>
  google_apis_<xsl:value-of select="sdk:api-level" /> = buildGoogleApis {
    name = "<xsl:value-of select="sdk:name-id" />-<xsl:value-of select="sdk:api-level" />";
      src = fetchurl {
        url = https://dl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive/sdk:url" />;
        sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
      };
      meta = {
        description = "<xsl:value-of select="sdk:description" />";
<xsl:for-each select="sdk:desc-url">        url = <xsl:value-of select="." />;</xsl:for-each>
      };
    };
</xsl:for-each>

<xsl:for-each select="sdk:extra[sdk:path='support']">
  android_support_extra = buildGoogleApis {
    name = "android_support_extra";
    src = fetchurl {
      url = https://dl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive/sdk:url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "Android Support Library";
      url = http://developer.android.com/;
    };
  };
</xsl:for-each><xsl:for-each select="sdk:extra[sdk:path='google_play_services']">
  google_play_services = buildGoogleApis {
    name = "google_play_services";
    src = fetchurl {
      url = https://dl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive/sdk:url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "Google Play services client library and sample code";
      url = http://developer.android.com/;
    };
  };
</xsl:for-each>
}
</xsl:template>

</xsl:stylesheet>
