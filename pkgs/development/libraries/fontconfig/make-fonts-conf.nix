{ runCommand, libxslt, fontconfig, fontbhttf, fontDirectories }:

runCommand "fonts.conf"
  {
    buildInputs = [ libxslt fontconfig ];
    # Add a default font for non-nixos systems. fontbhttf is only about 1mb.
    fontDirectories = fontDirectories ++ [ fontbhttf ];
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam fontconfig "${fontconfig.out}" \
      --stringparam fontconfigConfigVersion "${fontconfig.configVersion}" \
      --path ${fontconfig.out}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig.out}/etc/fonts/fonts.conf \
      > $out
  ''
