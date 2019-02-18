<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:addon="http://schemas.android.com/sdk/android/repo/addon2/01"
  xmlns:sdk="http://schemas.android.com/repository/android/common/01"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output omit-xml-declaration="yes" indent="no" />

  <!-- Template that puts a google HTTP prefix in front of relative URLs -->
  <xsl:template name="repository-url">
    <xsl:variable name="raw-url" select="complete/url"/>
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

  <xsl:template match="/addon:sdk-addon">
{fetchurl}:

{
  addons = {
    <!-- Convert all addons, but skip the entry for google APIs version 25 because it is inconsistent with the spec -->
    <xsl:for-each select="remotePackage[type-details/@xsi:type='addon:addonDetailsType' and archives/archive/complete/url != 'google_apis-25_r1.zip' ]"><xsl:sort select="@path" />
    "<xsl:value-of select="type-details/api-level" />"."<xsl:value-of select="type-details/tag/id" />" = {
      name = "<xsl:value-of select="type-details/tag/id" />";
      path = "<xsl:value-of select="translate(@path, ';', '/')" />";
      revision = "<xsl:value-of select="type-details/api-level" />";
      displayName = "<xsl:value-of select="display-name" />";
      archives = {
      <xsl:for-each select="archives/archive[not(host-os)]">
        all = fetchurl {
          url = <xsl:call-template name="repository-url"/>;
          sha1 = "<xsl:value-of select="complete/checksum" />";
        };
      </xsl:for-each>
      <xsl:for-each select="archives/archive[host-os and not(host-os = 'windows')]">
        <xsl:value-of select="host-os" /> = fetchurl {
          url = <xsl:call-template name="repository-url"/>;
          sha1 = "<xsl:value-of select="complete/checksum" />";
        };
      </xsl:for-each>
      };
    };
    </xsl:for-each>

    <!-- Workaround to make google APIs version 25 work. Hopefully, we can get rid of this at some point -->
    <xsl:for-each select="remotePackage[type-details/@xsi:type='addon:addonDetailsType' and archives/archive/complete/url = 'google_apis-25_r1.zip' ]">
    "<xsl:value-of select="25" />"."<xsl:value-of select="type-details/tag/id" />" = {
      name = "<xsl:value-of select="type-details/tag/id" />";
      path = "add-ons/addon-google_apis-google-25";
      revision = "<xsl:value-of select="25" />";
      displayName = "<xsl:value-of select="display-name" />";
      archives = {
      <xsl:for-each select="archives/archive[not(host-os)]">
        all = fetchurl {
          url = <xsl:call-template name="repository-url"/>;
          sha1 = "<xsl:value-of select="complete/checksum" />";
        };
      </xsl:for-each>
      <xsl:for-each select="archives/archive[host-os and not(host-os = 'windows')]">
        <xsl:value-of select="host-os" /> = fetchurl {
          url = <xsl:call-template name="repository-url"/>;
          sha1 = "<xsl:value-of select="complete/checksum" />";
        };
      </xsl:for-each>
      };
    };
    </xsl:for-each>
  };

  extras = {
    <!-- Convert all extras and maven artefacts -->
    <xsl:for-each select="remotePackage[type-details/@xsi:type='addon:extraDetailsType' or type-details/@xsi:type='addon:mavenType']"><xsl:sort select="@path" />
    
    <!-- Compose revision string from revision attributes -->
    <xsl:variable name="revision">
      <xsl:choose>
        <xsl:when test="revision/major">
          <xsl:value-of select="revision/major" />
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="revision/minor">.<xsl:value-of select="revision/minor" />
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="revision/micro">.<xsl:value-of select="revision/micro" />
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="revision/preview">-rc<xsl:value-of select="revision/preview" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    "<xsl:value-of select="@path" />" = {
      name = "<xsl:value-of select="translate(@path, ';', '-')" />";
      path = "<xsl:value-of select="translate(@path, ';', '/')" />";
      revision = "<xsl:value-of select="$revision" />";
      displayName = "<xsl:value-of select="display-name" />";
      archives = {
      <xsl:for-each select="archives/archive[not(host-os)]">
        all = fetchurl {
          url = <xsl:call-template name="repository-url"/>;
          sha1 = "<xsl:value-of select="complete/checksum" />";
        };
      </xsl:for-each>
      <xsl:for-each select="archives/archive[host-os and not(host-os = 'windows')]">
        <xsl:value-of select="host-os" /> = fetchurl {
          url = <xsl:call-template name="repository-url"/>;
          sha1 = "<xsl:value-of select="complete/checksum" />";
        };
      </xsl:for-each>
      };
    };
    </xsl:for-each>
  };
}
  </xsl:template>

</xsl:stylesheet>
