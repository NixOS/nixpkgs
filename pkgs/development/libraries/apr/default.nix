{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "apr-1.2.7";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/apr-1.2.7.tar.bz2;
    md5 = "e77887dbafc515c63feac84686bcb3bc";
  };
}
