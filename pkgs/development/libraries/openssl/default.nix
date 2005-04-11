{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.7f";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/openssl-0.9.7f.tar.gz;
    md5 = "b2d37d7eb8a5a5040d834105d5ae1a50";
  };
  inherit perl;
}
