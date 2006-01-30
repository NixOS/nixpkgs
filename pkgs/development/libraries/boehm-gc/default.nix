{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-6.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gc6.5.tar.gz;
    md5 = "00bf95cdcbedfa7321d14e0133b31cdb";
  };
}
