{ runCommand, stdenv, lib, libxslt, fontconfig, dejavu_fonts }:

let fontconfig_ = fontconfig; in
{
  fontconfig ? fontconfig_
  # an array of fonts, e.g. `[ pkgs.dejavu_fonts.minimal ]`
,  fontDirectories
  , impureFontDirectories ? [
    # nix user profile
    "~/.nix-profile/lib/X11/fonts" "~/.nix-profile/share/fonts"
  ]
  ++ lib.optional stdenv.isDarwin "~/Library/Fonts"
  ++ [
    # FHS paths for non-NixOS platforms
    "/usr/share/fonts" "/usr/local/share/fonts"
  ]
  # darwin paths
  ++ lib.optionals stdenv.isDarwin [ "/Library/Fonts" "/System/Library/Fonts" ]
  # nix default profile
  ++ [ "/nix/var/nix/profiles/default/lib/X11/fonts" "/nix/var/nix/profiles/default/share/fonts" ]
}:

runCommand "fonts.conf"
  {
    nativeBuildInputs = [ libxslt ];
    buildInputs = [ fontconfig ];
    inherit fontDirectories;
    # Add a default font for non-nixos systems, <1MB and in nixos defaults.
    impureFontDirectories = impureFontDirectories ++ [ dejavu_fonts.minimal ];
  }
  ''
    xsltproc --stringparam fontDirectories "$fontDirectories" \
      --stringparam impureFontDirectories "$impureFontDirectories" \
      --path ${fontconfig.out}/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} ${fontconfig.out}/etc/fonts/fonts.conf \
      > $out
  ''
