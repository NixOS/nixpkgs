{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdcss-1.2.8";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libdvdcss-1.2.8.tar.gz;
    md5 = "e35e4240b6ca0b66a0218065dffe6adb";
  };
}
