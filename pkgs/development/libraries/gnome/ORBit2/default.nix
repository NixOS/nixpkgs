{stdenv, fetchurl, pkgconfig, glib, libIDL, popt}:

assert pkgconfig != null && glib != null && libIDL != null
  && popt != null;

stdenv.mkDerivation {
  name = "ORBit2-2.8.3";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/ORBit2-2.8.3.tar.bz2;
    md5 = "c6c4b63de2f70310e33a52a37257ddaf";
  };
  buildInputs = [pkgconfig libIDL popt];
  propagatedBuildInputs = [glib];
}
