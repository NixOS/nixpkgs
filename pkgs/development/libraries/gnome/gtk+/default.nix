{input, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng}:

assert pkgconfig != null && x11 != null && glib != null && atk != null
  && pango != null && perl != null && perl != null && libtiff != null
  && libjpeg != null && libpng != null;
assert x11.buildClientLibs;
#assert glib == atk.glib;
#assert glib == pango.glib;
#assert x11 == pango.x11;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl libtiff libjpeg libpng];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
