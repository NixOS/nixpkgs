{stdenv, fetchurl, SDL, qt, pkgconfig, ffmpeg, libdv, libxml2, libsamplerate,
libvorbis, sox}:

stdenv.mkDerivation {
  name = "mlt-0.6.2";

  src = fetchurl {
    url = mirror://sourceforge/mlt/mlt-0.6.2.tar.gz;
    sha256 = "0rvyblxyp52mdjl4aicrk16k56yb24ic4ir3n145cxdarwi98r7i";
  };

  buildInputs = [ qt SDL ffmpeg libdv libxml2 libsamplerate libvorbis sox ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [ "--enable-gpl" "--avformat-swscale" ];

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv2+";
  };
}
