{stdenv, fetchurl, pkgconfig, libX11}:

stdenv.mkDerivation {
  name = "libXv-2.2.1";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXv-2.2.1.tar.bz2;
    md5 = "89b8ca62a77c662a8a7ded89bcf0dd67";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11];
}
