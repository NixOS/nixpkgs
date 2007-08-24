{stdenv, fetchurl, pkgconfig, glib}:

assert pkgconfig != null && glib != null;

stdenv.mkDerivation {
  name = "gnet-2.0.7";
  src = fetchurl {
    url = http://www.gnetlibrary.org/src/gnet-2.0.7.tar.gz;
    md5 = "3a7a40411775688fe4c42141ab007048";
  };
  buildInputs = [pkgconfig glib];
}
