{stdenv, fetchurl, pkgconfig, xproto, libX11, libXt, libXext, patch}:

stdenv.mkDerivation {
  name = "libXmu-6.2.3";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/libXmu-6.2.3.tar.bz2;
    md5 = "7671745bd8a1b0595847541479a327d6";
  };
  buildInputs = [pkgconfig patch];
  propagatedBuildInputs = [xproto libX11 libXt libXext];
  patches = ./no-Xaw.patch;
}
