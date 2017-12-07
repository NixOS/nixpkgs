{ stdenv, fetchurl, pkgconfig, gnome3, intltool }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
