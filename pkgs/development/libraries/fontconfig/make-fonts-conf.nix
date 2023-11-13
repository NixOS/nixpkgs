{ runCommand, stdenv, lib, libxslt, fontconfig, dejavu_fonts, fontDirectories }:

runCommand "fonts.conf"
  {
    nativeBuildInputs = [ libxslt ];
    buildInputs = [ fontconfig ];
    # Add a default font for non-nixos systems, <1MB and in nixos defaults.
    fontDirectories = fontDirectories ++ [ dejavu_fonts.minimal ]
      # further non-nixos fonts on darwin
      ++ lib.optionals stdenv.isDarwin [ "/System/Library/Fonts" "/Library/Fonts" "~/Library/Fonts" ];
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --path ${fontconfig.out}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig.out}/etc/fonts/fonts.conf \
      > $out
  ''
