{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libogg-1.1.4";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/ogg/libogg-1.1.4.tar.gz;
    sha256 = "00z15ha73yfv7zn9z2z5yvc8g53ci6vn12vpc0l7qhc8zn1w2m4k";
  };
}
