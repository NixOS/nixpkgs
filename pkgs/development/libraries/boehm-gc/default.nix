{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-6.8";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gc6.8.tar.gz;
    md5 = "418d38bd9c66398386a372ec0435250e";
  };
}
