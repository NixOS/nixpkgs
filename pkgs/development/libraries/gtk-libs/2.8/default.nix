{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, gettext, perl, x11
, libtiff, libjpeg, libpng, cairo, libXinerama ? null
}:

rec {

  glib = (import ./glib) {
    inherit fetchurl stdenv pkgconfig gettext perl;
  };

  atk = (import ./atk) {
    inherit fetchurl stdenv pkgconfig glib perl;
  };

  pango = (import ./pango) {
    inherit fetchurl stdenv pkgconfig glib x11 cairo;
  };

  gtk = (import ./gtk+) {
    inherit fetchurl stdenv pkgconfig glib atk pango perl
            libtiff libjpeg libpng x11 cairo libXinerama
            xineramaSupport;
  };

}
