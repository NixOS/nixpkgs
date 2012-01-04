{ stdenv, fetchurl, pkgconfig, glib, cairo, fontconfig
, libtiff, giflib, libungif, libjpeg, libpng, monoDLLFixer,
libXrender, libexif }:

stdenv.mkDerivation {
  name = "libgdiplus-2.10";

  src = fetchurl {
    url = http://download.mono-project.com/sources/libgdiplus/libgdiplus-2.10.tar.bz2;
    sha256 = "190j6yvfbpg6bda4n7pdcf2dbqdvrb4dmz5abs2yv0smxybh77id";
  };

  buildInputs = [ pkgconfig glib cairo fontconfig libtiff giflib libungif
     libjpeg libpng libXrender libexif ];
}
