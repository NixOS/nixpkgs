{runCommand, libxslt, fontconfig, fontDirectories}:

runCommand "fonts.conf"
  { 
    buildInputs = [libxslt];
    inherit fontDirectories;
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam fontconfig "${fontconfig}" \
      ${./make-fonts-conf.xsl} ${fontconfig}/etc/fonts/fonts.conf \
      > $out
  ''
