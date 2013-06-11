{ stdenv, fetchurl, SDL, ffmpeg, libdv, libsamplerate, libvorbis
, libxml2 , pkgconfig, qt4, sox, gtk2 }:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "0.8.8";

  src = fetchurl {
    url = "mirror://sourceforge/mlt/${name}.tar.gz";
    sha256 = "0m4nzxli1pl8w59m4iwwhpmr1xdz7xfknmbl3a0mkkd1jzdiq3nc";
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
