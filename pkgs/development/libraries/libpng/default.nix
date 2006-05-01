{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.10";
  src = fetchurl {
    url = ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.10.tar.bz2;
    md5 = "4f23eebd59ddd01a8f91ff8c823dd7d6";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
