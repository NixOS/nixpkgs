{stdenv, fetchurl, SDL, qt4, pkgconfig, ffmpeg, libdv, libxml2, libsamplerate,
libvorbis, sox}:

stdenv.mkDerivation {
  name = "mlt-0.7.8";

  src = fetchurl {
    url = mirror://sourceforge/mlt/mlt-0.7.8.tar.gz;
    sha256 = "0hvfjk0hspamym0ahi635ivx9iv3v2jy2qv15za1vmz28qkkp0wm";
  };

  buildInputs = [ qt4 SDL ffmpeg libdv libxml2 libsamplerate libvorbis sox pkgconfig ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [ "--enable-gpl" "--avformat-swscale" ];

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv2+";
  };
}
