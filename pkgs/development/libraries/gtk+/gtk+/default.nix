{ stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng}:

assert pkgconfig != null && x11 != null && glib != null && atk != null
  && pango != null && perl != null && perl != null && libtiff != null
  && libjpeg != null && libpng != null;
assert x11.buildClientLibs;
#assert glib == atk.glib;
#assert glib == pango.glib;
#assert x11 == pango.x11;

stdenv.mkDerivation {
  name = "gtk+-2.4.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.4/gtk+-2.4.0.tar.bz2;
    md5 = "fd16157de447c7f0a86495ad0dc67a1b";
  };
  buildInputs = [pkgconfig perl libtiff libjpeg libpng];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
