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
  name = "gtk+-2.4.13";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gtk+-2.4.13.tar.bz2;
    md5 = "3a438e1010704b11acaf060c9ba0fd7b";
  };
  buildInputs = [pkgconfig perl libtiff libjpeg libpng];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
