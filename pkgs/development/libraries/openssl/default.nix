{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.7d";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/openssl-0.9.7d.tar.gz;
    md5 = "1b49e90fc8a75c3a507c0a624529aca5";
  };
  inherit perl;
}
