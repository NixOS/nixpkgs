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
  name = "gtk+-2.6.4";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gtk+-2.6.4.tar.bz2;
    md5 = "4749fce7b082b784a71a076aa586dc25";
  };
  buildInputs = [pkgconfig perl libtiff libjpeg libpng];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
