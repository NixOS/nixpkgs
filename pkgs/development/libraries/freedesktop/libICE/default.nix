{stdenv, fetchurl, pkgconfig, libX11}:

stdenv.mkDerivation {
  name = "libICE-6.3.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libICE-6.3.2.tar.bz2;
    md5 = "06db02e3df846b127a6e2dc3e345039c";
  };
  buildInputs = [pkgconfig libX11];
}
