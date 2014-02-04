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

  <xsl:output method='xml' encoding="UTF-8" doctype-system="fonts.dtd" />

  <xsl:param name="fontDirectories" />
  <xsl:param name="fontconfig" />

  <xsl:template match="/fontconfig">

    <fontconfig>
      <xsl:copy-of select="child::node()[name() != 'dir' and name() != 'cachedir' and name() != 'include']" />

      <include ignore_missing="yes">/etc/fonts/conf.d</include>
      <include><xsl:value-of select="$fontconfig" />/etc/fonts/conf.d</include>

      <cachedir>/var/cache/fontconfig</cachedir>
      <cachedir>~/.fontconfig</cachedir>

      <xsl:for-each select="str:tokenize($fontDirectories)">
        <dir><xsl:value-of select="." /></dir>
        <xsl:text>&#0010;</xsl:text>
      </xsl:for-each>

    </fontconfig>

  </xsl:template>

</xsl:stylesheet>
