{stdenv, fetchurl, SDL, qt, pkgconfig, ffmpeg, libdv, libxml2, libsamplerate,
libvorbis, sox}:

stdenv.mkDerivation {
  name = "mlt-0.5.10";

  src = fetchurl {
    url = mirror://sourceforge/mlt/mlt-0.5.10.tar.gz;
    sha256 = "17nil3snm6qgcyld852ys0kqm61cx94zb3bvjdqgci6z1ia3crhh";
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
