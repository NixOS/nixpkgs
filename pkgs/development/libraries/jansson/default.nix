{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "jansson";
  version = "2.13.1";

  src = fetchurl {
    url = "https://digip.org/jansson/releases/${pname}-${version}.tar.gz";
    sha256 = "0ks7gbs0j8p4dmmi2sq129mxy5gfg0z6220i1jk020mi2zd7gwzl";
  };

  meta = with lib; {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
