{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig glib gtk3 enchant isocodes ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
