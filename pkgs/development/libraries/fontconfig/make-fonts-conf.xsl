<?xml version="1.0"?>

<!--
  This script copies the original fonts.conf from the fontconfig
  distribution, but replaces all <dir> entries with the directories
  specified in the $fontDirectories parameter.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str"
                >

  <xsl:output method='xml' encoding="UTF-8" doctype-system="urn:fontconfig:fonts.dtd" />

  <xsl:param name="fontDirectories" />
  <xsl:param name="impureFontDirectories" />

  <xsl:template match="/fontconfig">

    <fontconfig>
      <xsl:apply-templates select="child::node()[name() != 'dir' and name() != 'cachedir' and name() != 'include']" />

      <!-- the first cachedir will be used to store the cache -->
      <cachedir prefix="xdg">fontconfig</cachedir>
      <xsl:text>&#0010;</xsl:text>
      <!-- /var/cache/fontconfig is useful for non-nixos systems -->
      <cachedir>/var/cache/fontconfig</cachedir>
      <xsl:text>&#0010;</xsl:text>

      <!-- system-wide config -->
      <include ignore_missing="yes">/etc/fonts/conf.d</include>
      <xsl:text>&#0010;</xsl:text>

      <dir prefix="xdg">fonts</dir>
      <xsl:text>&#0010;</xsl:text>
      <xsl:for-each select="str:tokenize($fontDirectories)">
        <dir><xsl:value-of select="." /></dir>
        <xsl:text>&#0010;</xsl:text>
      </xsl:for-each>

      <xsl:for-each select="str:tokenize($impureFontDirectories)">
        <dir><xsl:value-of select="." /></dir>
        <xsl:text>&#0010;</xsl:text>
      </xsl:for-each>

    </fontconfig>

  </xsl:template>


  <!-- New fontconfig >=2.11 doesn't like xml:space added by xsl:copy-of -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*[name() != 'xml:space']"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
