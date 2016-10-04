{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmpcdec-1.2.6";
  src = fetchurl {
    url = http://files.musepack.net/source/libmpcdec-1.2.6.tar.bz2;
    md5 = "7f7a060e83b4278acf4b77d7a7b9d2c0";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
