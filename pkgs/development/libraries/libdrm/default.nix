{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdrm-2.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libdrm-2.0.tar.gz;
    md5 = "9d1aab104eb757ceeb2c1a6d38d57411";
  };
}
