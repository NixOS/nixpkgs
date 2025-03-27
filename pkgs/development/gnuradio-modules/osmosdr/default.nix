{ lib
, stdenv
, mkDerivation
, fetchgit
, gnuradio
, cmake
, pkg-config
, logLib
, libsndfile
, mpir
, boost
, gmp
, thrift
, fftwFloat
, python
, uhd
, icu
, airspy
, hackrf
, libbladeRF
, rtl-sdr
, soapysdr-with-plugins
, gnuradioAtLeast
}:

mkDerivation rec {
  pname = "gr-osmosdr";
  version = "0.2.6";

  src = fetchgit {
    url = "https://gitea.osmocom.org/sdr/gr-osmosdr";
    rev = "v${version}";
    hash = "sha256-jCUzBY1pYiEtcRQ97t9F6uEMVYw2NU0eoB5Xc2H6pGQ=";
  };

  disabled = gnuradioAtLeast "3.11";

  outputs = [ "out" "dev" ];

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
  ] ++ lib.optionals (gnuradio.hasFeature "gr-blocks") [
    libsndfile
  ] ++ lib.optionals (gnuradio.hasFeature "gr-uhd") [
    uhd
  ] ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    python.pkgs.thrift
  ] ++ lib.optionals (gnuradio.hasFeature "python-support") [
      python.pkgs.numpy
      python.pkgs.pybind11
  ];
  cmakeFlags = [
    (if (gnuradio.hasFeature "python-support") then
      "-DENABLE_PYTHON=ON"
    else
      "-DENABLE_PYTHON=OFF"
    )
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals (gnuradio.hasFeature "python-support") [
      python.pkgs.mako
      python
    ]
  ;

  meta = {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.unix;
  };
}
