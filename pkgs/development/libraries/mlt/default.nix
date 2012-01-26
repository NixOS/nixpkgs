{stdenv, fetchurl, SDL, qt4, pkgconfig, ffmpeg, libdv, libxml2, libsamplerate,
libvorbis, sox}:

stdenv.mkDerivation {
  name = "mlt-0.7.6";

  src = fetchurl {
    url = mirror://sourceforge/mlt/mlt-0.7.6.tar.gz;
    sha256 = "f8ea8590417ea2b5543a495f2edc30636d3931932deee7a4e0d8516e9c2b58ae";
  };

  buildInputs = [ qt4 SDL ffmpeg libdv libxml2 libsamplerate libvorbis sox ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [ "--enable-gpl" "--avformat-swscale" ];

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv2+";
  };
}
