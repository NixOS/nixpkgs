{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes, vala }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedBuildInputs = [ enchant ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig vala ];
  buildInputs = [ glib gtk3 isocodes ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
