<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sys-img="http://schemas.android.com/sdk/android/repo/sys-img2/01"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:param name="imageType" />

  <xsl:output omit-xml-declaration="yes" indent="no" />

  <xsl:template name="repository-url">
    <xsl:variable name="raw-url" select="complete/url"/>
    <xsl:choose>
      <xsl:when test="starts-with($raw-url, 'http')">
        <xsl:value-of select="$raw-url"/>
      </xsl:when>
      <xsl:otherwise>
        https://dl.google.com/android/repository/sys-img/<xsl:value-of select="$imageType" />/<xsl:value-of select="$raw-url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/sys-img:sdk-sys-img">
{fetchurl}:

{
  <xsl:for-each select="remotePackage[starts-with(@path, 'system-images;')]">
    <xsl:variable name="revision">
      <xsl:value-of select="type-details/api-level" />-<xsl:value-of select="type-details/tag/id" />-<xsl:value-of select="type-details/abi" />
    </xsl:variable>

    "<xsl:value-of select="type-details/api-level" />".<xsl:value-of select="type-details/tag/id" />."<xsl:value-of select="type-details/abi" />" = {
      name = "system-image-<xsl:value-of select="$revision" />";
      path = "<xsl:value-of select="translate(@path, ';', '/')" />";
      revision = "<xsl:value-of select="$revision" />";
      displayName = "<xsl:value-of select="display-name" />";
      archives.all = fetchurl {
      <xsl:for-each select="archives/archive">
        url = <xsl:call-template name="repository-url"/>;
        sha1 = "<xsl:value-of select="complete/checksum" />";
      </xsl:for-each>
      };
  };
  </xsl:for-each>
}
  </xsl:template>
</xsl:stylesheet>
