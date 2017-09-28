{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes, vala }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedBuildInputs = [ enchant ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gtk3 isocodes vala ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
