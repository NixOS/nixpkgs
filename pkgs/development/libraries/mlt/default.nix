{stdenv, fetchurl, SDL, qt4, pkgconfig, ffmpeg, libdv, libxml2, libsamplerate,
libvorbis, sox}:

stdenv.mkDerivation {
  name = "mlt-0.7.4";

  src = fetchurl {
    url = mirror://sourceforge/mlt/mlt-0.7.4.tar.gz;
    sha256 = "1xcrrd3xbz9hmahgl7xf610cm97chwpxwgcajkd10mpcxbqs08i0";
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
