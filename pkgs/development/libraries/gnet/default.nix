{stdenv, fetchurl, pkgconfig, glib}:

assert pkgconfig != null && glib != null;

stdenv.mkDerivation {
  name = "gnet-2.0.5";
  src = fetchurl {
    url = http://www.gnetlibrary.org/src/gnet-2.0.5.tar.gz;
    md5 = "126f140618de34801933d192302ed0b9";
  };
  buildInputs = [pkgconfig glib];
}
