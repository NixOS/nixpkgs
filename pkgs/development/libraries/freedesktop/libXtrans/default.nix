{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libXtrans-0.1";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXtrans-0.1.tar.bz2;
    md5 = "a5ae4c7a75f930053b8327f7bd0c1361";
  };
}
