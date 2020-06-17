{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.13.1";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "0ks7gbs0j8p4dmmi2sq129mxy5gfg0z6220i1jk020mi2zd7gwzl";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
