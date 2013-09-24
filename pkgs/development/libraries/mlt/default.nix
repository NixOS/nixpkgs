{ stdenv, fetchurl, SDL, ffmpeg, libdv, libsamplerate, libvorbis
, libxml2 , pkgconfig, qt4, sox, gtk2 }:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/mlt/${name}.tar.gz";
    sha256 = "1j8wbkwpa6k5anyf4nvf71l8251d7clzj6v09jl3vvfakaf6l37j";
  };

  buildInputs =
    [ SDL ffmpeg libdv libsamplerate libvorbis libxml2 pkgconfig qt4
      sox # gtk2 /*optional*/
    ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [ "--enable-gpl" "--enable-gpl3" "--avformat-swscale" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv3";
  };
}
