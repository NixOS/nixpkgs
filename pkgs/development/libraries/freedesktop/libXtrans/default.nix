{stdenv, fetchurl}:

derivation {
  name = "libXtrans-0.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXtrans-0.1.tar.bz2;
    md5 = "a5ae4c7a75f930053b8327f7bd0c1361";
  };
  inherit stdenv;
}
