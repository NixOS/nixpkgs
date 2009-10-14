{ stdenv, fetchurl, pkgconfig, fftw, libsndfile, libsamplerate
, python, alsaLib, jackaudio }:

stdenv.mkDerivation rec {
  name = "aubio-0.3.2";

  src = fetchurl {
    url = "http://aubio.org/pub/${name}.tar.gz";
    sha256 = "1k8j2m8wdpa54hvrqy6nqfcx42x6nwa77hi3ym0n22k192q8f4yw";
  };

  buildInputs =
    [ pkgconfig fftw libsndfile libsamplerate python
      # optional:
      alsaLib jackaudio
    ];

  meta = { 
    description = "A library for audio labelling";
    homepage = http://aubio.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
