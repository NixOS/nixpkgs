{ runCommand, libxslt, fontconfig, fontDirectories }:

runCommand "fonts.conf"
  {
    buildInputs = [ libxslt fontconfig ];
    inherit fontDirectories;
  }
  ''
    for fd in $fontDirectories;
    do
      if [ ! -d "$fd/share/fonts" ] && [ ! -d "$fd/lib/X11/fonts" ]; then
        echo "ERROR: '$fd/' contains neither 'share/fonts/' nor 'lib/X11/fonts/'"
        false
      fi
    done

    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam fontconfig "${fontconfig}" \
      --path ${fontconfig}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig}/etc/fonts/fonts.conf \
      > $out
  ''
