{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fftw,
  libjack2,
  libsamplerate,
  libsndfile,
  pkg-config,
  python3,
  wafHook,
}:

stdenv.mkDerivation rec {
  pname = "aubio";
  version = "0.4.9";

  src = fetchurl {
    url = "https://aubio.org/pub/aubio-${version}.tar.bz2";
    sha256 = "1npks71ljc48w6858l9bq30kaf5nph8z0v61jkfb70xb9np850nl";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    wafHook
  ];
  buildInputs = [
    alsa-lib
    fftw
    libjack2
    libsamplerate
    libsndfile
  ];

  strictDeps = true;
  dontAddWafCrossFlags = true;
  wafFlags = lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--disable-tests";

  postPatch = ''
    # U was removed in python 3.11 because it had no effect
    substituteInPlace waflib/*.py \
      --replace "m='rU" "m='r" \
      --replace "'rU'" "'r'"
  '';

  meta = with lib; {
    description = "Library for audio labelling";
    homepage = "https://aubio.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      goibhniu
      marcweber
      fpletz
    ];
    platforms = platforms.linux;
  };
}
