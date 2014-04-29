{ runCommand, libxslt, fontconfig, fontDirectories }:

runCommand "fonts.conf"
  {
    buildInputs = [ libxslt fontconfig ];
    inherit fontDirectories;
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam fontconfig "${fontconfig}" \
      --path ${fontconfig}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig}/etc/fonts/fonts.conf \
      > $out
  ''
