{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.5";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "1cdi1g4pyjwrw76z99ys8cr13iz9nz9i8sq6ivl1q0ymiarvz2yx";
  };

  meta = {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = "MIT";
  };
}
