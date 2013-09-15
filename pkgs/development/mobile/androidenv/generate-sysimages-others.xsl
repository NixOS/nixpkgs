<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:sdk="http://schemas.android.com/sdk/android/sys-img/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:param name="abi" />
  <xsl:output omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/sdk:sdk-sys-img">
    <xsl:for-each select="sdk:system-image">
  sysimg_<xsl:value-of select="sdk:abi" />_<xsl:value-of select="sdk:api-level" /> = buildSystemImage {
    name = "<xsl:value-of select="sdk:abi" />-<xsl:value-of select="sdk:api-level" />";
    src = fetchurl {
      url = https://dl-ssl.google.com/android/repository/sys-img/<xsl:value-of select="$abi" />/<xsl:value-of select="sdk:archives/sdk:archive[@os='any']/sdk:url" />;
      sha1 = "<xsl:value-of select="sdk:archives/sdk:archive[@os='any']/sdk:checksum[@type='sha1']" />";
    };
  };
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
