<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sys-img="http://schemas.android.com/sdk/android/repo/sys-img2/01"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:param name="imageType" />

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />

  <xsl:template name="repository-url">
    <xsl:variable name="raw-url" select="complete/url"/>
    <xsl:choose>
      <xsl:when test="starts-with($raw-url, 'http')">
        <xsl:value-of select="$raw-url"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>https://dl.google.com/android/repository/sys-img/</xsl:text><xsl:value-of select="$imageType" /><xsl:text>/</xsl:text><xsl:value-of select="$raw-url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="revision" match="type-details[codename]">
    <xsl:value-of select="codename" />-<xsl:value-of select="tag/id" />-<xsl:value-of select="abi" />
  </xsl:template>

  <xsl:template mode="revision" match="type-details[not(codename)]">
    <xsl:value-of select="api-level" />-<xsl:value-of select="tag/id" />-<xsl:value-of select="abi" />
  </xsl:template>

  <xsl:template mode="attrkey" match="type-details[codename]">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="codename" />
    <xsl:text>".</xsl:text>
    <xsl:value-of select="tag/id" />
    <xsl:text>."</xsl:text>
    <xsl:value-of select="abi" />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template mode="attrkey" match="type-details[not(codename)]">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="api-level" />
    <xsl:text>".</xsl:text>
    <xsl:value-of select="tag/id" />
    <xsl:text>."</xsl:text>
    <xsl:value-of select="abi" />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="/sys-img:sdk-sys-img">
<xsl:text>{fetchurl}:

{
</xsl:text><xsl:for-each select="remotePackage[starts-with(@path, 'system-images;')]">
  <xsl:variable name="revision"><xsl:apply-templates mode="revision" select="type-details" /></xsl:variable>

  <xsl:variable name="attrkey"><xsl:apply-templates mode="attrkey" select="type-details" /></xsl:variable>

  <xsl:text>  </xsl:text><xsl:value-of select="$attrkey" /><xsl:text> = {
    name = "system-image-</xsl:text><xsl:value-of select="$revision" /><xsl:text>";
    path = "</xsl:text><xsl:value-of select="translate(@path, ';', '/')" /><xsl:text>";
    revision = "</xsl:text><xsl:value-of select="$revision" /><xsl:text>";
    displayName = "</xsl:text><xsl:value-of select="display-name" /><xsl:text>";
    archives.all = fetchurl {</xsl:text>
    <xsl:for-each select="archives/archive"><xsl:text>
      url = </xsl:text><xsl:call-template name="repository-url"/><xsl:text>;
      sha1 = "</xsl:text><xsl:value-of select="complete/checksum" /><xsl:text>";</xsl:text>
    </xsl:for-each><xsl:text>
    };
  };
</xsl:text>
  </xsl:for-each>
<xsl:text>}</xsl:text>
  </xsl:template>
</xsl:stylesheet>
