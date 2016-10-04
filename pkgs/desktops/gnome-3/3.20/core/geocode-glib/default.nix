{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json_glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = with gnome3;
    [ intltool pkgconfig glib libsoup json_glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
