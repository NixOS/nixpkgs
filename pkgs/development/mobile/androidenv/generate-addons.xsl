<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdk="http://schemas.android.com/sdk/android/addon/7">

  <xsl:output omit-xml-declaration="yes" indent="no" />
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

<!-- Instant apps -->
<xsl:for-each select="sdk:extra[sdk:path='instantapps']">
  instant_apps = buildGoogleApis {
    name = "instant_apps_sdk";
    src = fetchurl {
      url = https://dl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive/sdk:url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "Android Instant Apps Development SDK";
      url = "https://developer.android.com/";
    };
  };
</xsl:for-each><xsl:for-each select="sdk:extra[sdk:path='m2repository']">
<xsl:text>  </xsl:text><xsl:value-of select="sdk:vendor-id"/>_m2repository = stdenv.mkDerivation rec {
    version = "<xsl:call-template name="revision"><xsl:with-param name="separator">.</xsl:with-param></xsl:call-template>";
    name = "<xsl:value-of select="sdk:vendor-id"/>_m2repository-${version}";
    src = fetchurl {
      url = https://dl.google.com/android/repository/<xsl:value-of select="sdk:archives/sdk:archive/sdk:url"/>;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
    };
    meta = {
      description = "<xsl:value-of select="sdk:name-display"/> - <xsl:value-of select="sdk:description"/>";
      url = http://developer.android.com/;
    };
    buildCommand = ''
      mkdir -p $out
      cd $out
      unzip $src
    '';

    buildInputs = [ unzip ];
  };
</xsl:for-each>

}
</xsl:template>

</xsl:stylesheet>
