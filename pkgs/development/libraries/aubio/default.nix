args: with args;
stdenv.mkDerivation {
  name = "aubio-";

  src = fetchurl {
    url = http://aubio.org/pub/aubio-0.3.2.tar.gz;
    sha256 = "1k8j2m8wdpa54hvrqy6nqfcx42x6nwa77hi3ym0n22k192q8f4yw";
  };

  buildInputs = [
    pkgconfig fftw libsndfile libsamplerate python
    # optional:
    alsaLib jackaudio
    ];

  meta = { 
    description = "ibrary for audio labelling";
    homepage = http://aubio.org/;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
