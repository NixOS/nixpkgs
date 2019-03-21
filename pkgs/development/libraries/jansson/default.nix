{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.12";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "1jfj4xq3rdgnkxval1x2gqwhaam34qdxbplsj5fsrvs8a1vfr3az";
  };

  meta = with stdenv.lib; {
    homepage = http://www.digip.org/jansson/;
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
