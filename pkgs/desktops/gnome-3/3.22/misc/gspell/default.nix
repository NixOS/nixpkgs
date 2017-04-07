{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes, vala }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig glib gtk3 enchant isocodes vala ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
