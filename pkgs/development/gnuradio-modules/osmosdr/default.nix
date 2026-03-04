{
  lib,
  stdenv,
  mkDerivation,
  fetchgit,
  fetchpatch,
  gnuradio,
  cmake,
  pkg-config,
  logLib,
  libsndfile,
  mpir,
  boost,
  gmp,
  thrift,
  fftwFloat,
  python,
  uhd,
  icu,
  airspy,
  hackrf,
  libbladeRF,
  rtl-sdr,
  soapysdr-with-plugins,
  gnuradioAtLeast,
}:

mkDerivation rec {
  pname = "gr-osmosdr";
  version = "0.2.6";

  src = fetchgit {
    url = "https://gitea.osmocom.org/sdr/gr-osmosdr";
    rev = "v${version}";
    hash = "sha256-jCUzBY1pYiEtcRQ97t9F6uEMVYw2NU0eoB5Xc2H6pGQ=";
  };

  patches = [
    # Fixes build with boost 1.89, see:
    # https://github.com/osmocom/gr-osmosdr/pull/29
    (fetchpatch {
      url = "https://github.com/osmocom/gr-osmosdr/commit/06249f1f0930aa553ef8877b50503b9f5c77b4a0.patch";
      hash = "sha256-ofjuDvTT2PzRTR6UWchTQzmr9a83ka5TfUdlCBe4Is0=";
    })
  ];

  disabled = gnuradioAtLeast "3.11";

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    logLib
    mpir
    boost
    fftwFloat
    gmp
    icu
    airspy
    hackrf
    libbladeRF
    rtl-sdr
    soapysdr-with-plugins
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-blocks") [
    libsndfile
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-uhd") [
    uhd
  ]
  ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    python.pkgs.thrift
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.numpy
    python.pkgs.pybind11
  ];
  cmakeFlags = [
    (if (gnuradio.hasFeature "python-support") then "-DENABLE_PYTHON=ON" else "-DENABLE_PYTHON=OFF")
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.mako
    python
  ];

  meta = {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.unix;
  };
}
