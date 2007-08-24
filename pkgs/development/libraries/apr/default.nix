{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "apr-1.2.7";
  src = fetchurl {
    url = http://archive.apache.org/dist/apr/apr-1.2.7.tar.bz2;
    md5 = "e77887dbafc515c63feac84686bcb3bc";
  };
}
