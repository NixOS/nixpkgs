{stdenv, fetchurl, pkgconfig, x11, glib, xft}:

assert pkgconfig != null && x11 != null && glib != null && xft != null;
assert x11.buildClientLibs;
assert xft.x11 == x11;

derivation {
  name = "pango-1.2.5";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.2/pango-1.2.5.tar.bz2;
    md5 = "df00fe3e71cd297010f24f439b6c8ee6";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  x11 = x11;
  glib = glib;
  xft = xft;
}
