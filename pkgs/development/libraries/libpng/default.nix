{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.12";
  src = fetchurl {
    url = ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.12.tar.bz2;
    md5 = "2287cfaad53a714acdf6eb75a7c1d15f";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
