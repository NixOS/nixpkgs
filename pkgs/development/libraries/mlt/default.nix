{stdenv, fetchurl, SDL, qt, pkgconfig, ffmpeg, libdv}:

stdenv.mkDerivation {
  name = "mlt-0.5.4";

  src = fetchurl {
    url = mirror://sourceforge/mlt/mlt-0.5.4.tar.gz;
    sha256 = "12s5znbm6q45r33ymyw1bak3d41xhh72gh9i1pdsgvddr0pizshj";
  };

  buildInputs = [ qt SDL ffmpeg libdv ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [ "--enable-gpl" "--avformat-swscale" ];

  meta = {
    homepage = http://www.mltframework.org/;
    description = "Open source multimedia framework, designed for television broadcasting";
    license = "GPLv2+";
  };
}
