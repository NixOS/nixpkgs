{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "libdvdcss-1.2.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.videolan.org/pub/videolan/vlc/0.6.2/contrib/libdvdcss-1.2.8.tar.gz;
    md5 = "e35e4240b6ca0b66a0218065dffe6adb";
  };
}
