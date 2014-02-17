{ stdenv, fetchurl, pkgconfig, fftw, libsndfile, libsamplerate
, python, alsaLib, jackaudio }:

stdenv.mkDerivation rec {
  name = "aubio-0.4.0";

  src = fetchurl {
    url = "http://aubio.org/pub/${name}.tar.bz2";
    sha256 = "18ik5nn8n984f0wnrwdfhc06b8blqgm9b2hrm7hc9m0rr039mpj9";
  };

  buildInputs =
    [ pkgconfig fftw libsndfile libsamplerate python
      # optional:
      alsaLib jackaudio
    ];

  meta = { 
    description = "Library for audio labelling";
    homepage = http://aubio.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
