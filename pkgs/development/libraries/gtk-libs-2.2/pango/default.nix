{stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.2.5";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/pango-1.2.5.tar.bz2;
    md5 = "df00fe3e71cd297010f24f439b6c8ee6";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}
