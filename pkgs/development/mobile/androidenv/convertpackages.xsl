<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:common="http://schemas.android.com/repository/android/common/01"
  xmlns:generic="http://schemas.android.com/repository/android/generic/01"
  xmlns:sdk="http://schemas.android.com/sdk/android/repo/repository2/01"
  xmlns:sdk-common="http://schemas.android.com/sdk/android/repo/common/01"
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

  <xsl:template match="/sdk:sdk-repository">
{fetchurl}:

{
  <!-- Convert all remote packages -->
  <xsl:for-each select="remotePackage"><xsl:sort select="@path" />

  <!-- Extract the package name from the path -->
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="contains(@path, ';')">
        <xsl:value-of select="substring-before(@path, ';')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@path" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Compose version string from version attributes -->
  <xsl:variable name="revision">
    <xsl:choose>
      <!-- Compose revision for a generic package from the revision attributes -->
      <xsl:when test="type-details/@xsi:type='generic:genericDetailsType'">
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
      </xsl:when>
      <!-- Compose revision of a platform SDK from the API-level or codename if the latter exists -->
      <xsl:when test="type-details/@xsi:type='sdk:platformDetailsType'">
        <xsl:choose>
          <xsl:when test="not(type-details/codename='')">
            <xsl:value-of select="type-details/codename" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="type-details/api-level" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Compose revision of a source SDK from the API-level -->
      <xsl:when test="type-details/@xsi:type='sdk:sourceDetailsType'">
        <xsl:value-of select="type-details/api-level" />
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@path='emulator'"> <!-- An emulator package provides one archive per operating system but the same versions -->
  "<xsl:value-of select="$name" />"."<xsl:value-of select="$revision" />".<xsl:value-of select="archives/archive/host-os" /> = {
    </xsl:when>
    <xsl:otherwise>
  "<xsl:value-of select="$name" />"."<xsl:value-of select="$revision" />" = {
    </xsl:otherwise>
  </xsl:choose>
    name = "<xsl:value-of select="$name" />";
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
}
  </xsl:template>
</xsl:stylesheet>
