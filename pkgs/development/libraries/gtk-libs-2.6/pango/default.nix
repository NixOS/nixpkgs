{stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.8.0";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/pango-1.8.0.tar.bz2;
    md5 = "d11f9857df7216321163e14d66d0cab8";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}
