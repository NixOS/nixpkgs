{stdenv, fetchurl, perl}: derivation {
  name = "openssl-0.9.7d";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.7d.tar.gz;
    md5 = "1b49e90fc8a75c3a507c0a624529aca5";
  };
  inherit stdenv perl;
}
