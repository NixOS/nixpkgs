{stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  name = "atk-1.2.4";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/atk-1.2.4.tar.bz2;
    md5 = "2d6d50df31abe0e8892b5d3e7676a02d";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}
