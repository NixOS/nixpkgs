{ stdenv, fetchurl, pkgconfig, gettext, perl, x11
, libtiff, libjpeg, libpng}:

rec {

  glib = (import ./glib) {
    inherit fetchurl stdenv pkgconfig gettext perl;
  };

  atk = (import ./atk) {
    inherit fetchurl stdenv pkgconfig glib perl;
  };

  pango = (import ./pango) {
    inherit fetchurl stdenv pkgconfig glib x11;
  };

  gtk = (import ./gtk+) {
    inherit fetchurl stdenv pkgconfig glib atk pango perl
            libtiff libjpeg libpng x11;
  };

}
