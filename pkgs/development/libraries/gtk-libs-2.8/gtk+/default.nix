{ stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo
}:

assert pkgconfig != null && x11 != null && glib != null && atk != null
  && pango != null && perl != null && perl != null && libtiff != null
  && libjpeg != null && libpng != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "gtk+-2.8.6";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/gtk+-2.8.6.tar.bz2;
    md5 = "2bcb9e3feb62ac895101cb8ee87ca49a";
  };
  buildInputs = [pkgconfig perl libtiff libjpeg libpng cairo];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
