{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "renderext-0.8";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/renderext-0.8.tar.bz2;
    md5 = "b00a97b00bf93ab2ac6442ea13ea9c0b";
  };
}
