{ runCommand, libxslt, fontconfig, dejavu_fonts, fontDirectories }:

runCommand "fonts.conf"
  {
    buildInputs = [ fontconfig ];
    nativeBuildInputs = [ libxslt ];
    # Add a default font for non-nixos systems, <1MB and in nixos defaults.
    fontDirectories = fontDirectories ++ [ dejavu_fonts.minimal ];
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam fontconfig "${fontconfig.out}" \
      --stringparam fontconfigConfigVersion "${fontconfig.configVersion}" \
      --path ${fontconfig.out}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig.out}/etc/fonts/fonts.conf \
      > $out
  ''
