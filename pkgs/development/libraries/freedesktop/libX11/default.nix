{stdenv, fetchurl, pkgconfig, xproto, xextensions, libXtrans, libXau}:

derivation {
  name = "libX11-6.2.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libX11-6.2.1.tar.bz2;
    md5 = "59b6fa7cd6fe7ee1da92fd1b56d1cee3";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto xextensions libXtrans libXau];
  inherit stdenv;
}
