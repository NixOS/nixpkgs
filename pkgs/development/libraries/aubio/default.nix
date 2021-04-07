{ lib, stdenv, fetchurl, alsaLib, fftw, libjack2, libsamplerate
, libsndfile, pkg-config, python3, wafHook
}:

stdenv.mkDerivation rec {
  name = "aubio-0.4.9";

  src = fetchurl {
    url = "https://aubio.org/pub/${name}.tar.bz2";
    sha256 = "1npks71ljc48w6858l9bq30kaf5nph8z0v61jkfb70xb9np850nl";
  };

  nativeBuildInputs = [ pkg-config python3 wafHook ];
  buildInputs = [ alsaLib fftw libjack2 libsamplerate libsndfile ];

  strictDeps = true;

  meta = with lib; {
    description = "Library for audio labelling";
    homepage = "https://aubio.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu marcweber fpletz ];
    platforms = platforms.linux;
  };
}
