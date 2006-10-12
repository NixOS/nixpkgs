{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.12";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libpng-1.2.12.tar.bz2;
    md5 = "2287cfaad53a714acdf6eb75a7c1d15f";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
