{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.4";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "1fcbd1ac3d8b610644acf86a5731d760bb228c9acbace20a2ad0f23baec79b41";
  };

  meta = {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = "MIT";
  };
}
