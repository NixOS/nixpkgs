{stdenv, fetchurl, pkgconfig, xproto, libX11, libXt}:

stdenv.mkDerivation {
  name = "libXmu-6.2.1";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libXmu-6.2.1.tar.bz2;
    md5 = "9bbdfe7eac185872cd1718d3f2014cf1";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto libX11 libXt];
}
