{stdenv, fetchurl, x11, libtiff, libjpeg, libpng}:

rec {

  glib = (import ./glib) {
    inherit fetchurl stdenv;
  };

  gtk = (import ./gtk+) {
    inherit fetchurl stdenv x11 glib;
  };

  gdkpixbuf = (import ./gdk-pixbuf) {
    inherit fetchurl stdenv gtk libtiff libjpeg libpng;
  };

}