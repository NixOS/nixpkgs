{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xextensions-1.0.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xextensions-1.0.1.tar.bz2;
    md5 = "e61bca2a4757b736c9557dc8a7df2217";
  };
}
