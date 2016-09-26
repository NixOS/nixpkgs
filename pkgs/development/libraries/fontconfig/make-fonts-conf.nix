{ runCommand, libxslt, fontconfig, dejavu, fontDirectories }:

runCommand "fonts.conf"
  {
    buildInputs = [ libxslt fontconfig ];
    # Add a default font for non-nixos systems, <1MB and in nixos defaults.
    fontDirectories = fontDirectories ++ [ dejavu.minimal ];
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam fontconfig "${fontconfig.out}" \
      --stringparam fontconfigConfigVersion "${fontconfig.configVersion}" \
      --path ${fontconfig.out}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig.out}/etc/fonts/fonts.conf \
      > $out
  ''
