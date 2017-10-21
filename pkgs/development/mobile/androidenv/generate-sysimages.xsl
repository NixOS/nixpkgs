<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:sdk="http://schemas.android.com/sdk/android/sys-img/3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/sdk:sdk-sys-img">
    <xsl:for-each select="sdk:system-image"><xsl:sort select="sdk:api-level" data-type="number"/><xsl:sort select="sdk:abi"/>
  sysimg_<xsl:value-of select="sdk:abi" />_<xsl:value-of select="sdk:api-level" /> = buildSystemImage {
    name = "sysimg-<xsl:value-of select="sdk:abi" />-<xsl:value-of select="sdk:api-level" />";
    src = fetchurl {
      url = <xsl:if test="not(starts-with(sdk:archives/sdk:archive/sdk:url, 'https://'))">https://dl.google.com/android/repository/sys-img/android/</xsl:if><xsl:value-of select="sdk:archives/sdk:archive/sdk:url" />;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive/sdk:checksum[@type='sha1']" />";
    };
  };
</xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
