{ stdenv, fetchurl, cmake, libpng, libtiff, lcms2 }:

stdenv.mkDerivation rec {
  name = "openjpeg-2.0.0";

  src = fetchurl {
    url = "http://openjpeg.googlecode.com/files/${name}.tar.gz";
    sha256 = "1n05yrmscpgksrh2kfh12h18l0lw9j03mgmvwcg3hm8m0lwgak9k";
  };

  configurePhase = "cmake";

  buildInputs = [ cmake libpng libtiff lcms2 ];

  meta = {
    homepage = http://www.openjpeg.org/;
    description = "Open-source JPEG 2000 codec written in C language";
    license = "BSD";
    platforms = stdenv.lib.platforms.all;
  };
}
