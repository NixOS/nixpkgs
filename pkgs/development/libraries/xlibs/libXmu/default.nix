{stdenv, fetchurl, pkgconfig, xproto, libX11, libXt, libXext}:

stdenv.mkDerivation {
  name = "libXmu-6.2.3";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libXmu-6.2.3.tar.bz2;
    md5 = "7671745bd8a1b0595847541479a327d6";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto libX11 libXt libXext];
  patches = ./no-Xaw.patch;
}
