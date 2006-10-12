{stdenv, fetchurl, pkgconfig, x11, glib, cairo, libpng}:

assert x11.buildClientLibs;

stdenv.mkDerivation {
  name = "pango-1.12.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pango-1.12.3.tar.bz2;
    md5 = "c8178e11a895166d86990bb2c38d831b";
  };
  buildInputs = [pkgconfig libpng];
  propagatedBuildInputs = [x11 glib cairo];
}
