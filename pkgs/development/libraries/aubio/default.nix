{ lib, stdenv, fetchurl, alsa-lib, fftw, libjack2, libsamplerate
<<<<<<< HEAD
, libsndfile, pkg-config, python3, waf
=======
, libsndfile, pkg-config, python3, wafHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "aubio";
  version = "0.4.9";

  src = fetchurl {
    url = "https://aubio.org/pub/aubio-${version}.tar.bz2";
    sha256 = "1npks71ljc48w6858l9bq30kaf5nph8z0v61jkfb70xb9np850nl";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config python3 waf.hook ];
=======
  nativeBuildInputs = [ pkg-config python3 wafHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ alsa-lib fftw libjack2 libsamplerate libsndfile ];

  strictDeps = true;
  dontAddWafCrossFlags = true;
  wafFlags = lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--disable-tests";

  meta = with lib; {
    description = "Library for audio labelling";
    homepage = "https://aubio.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu marcweber fpletz ];
    platforms = platforms.linux;
  };
}
