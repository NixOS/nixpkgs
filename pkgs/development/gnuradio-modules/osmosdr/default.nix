{ lib
, mkDerivation
, fetchgit
, gnuradio
, cmake
, pkg-config
, log4cpp
, mpir
, boost
, gmp
, fftwFloat
, python
, swig
, uhd
, icu
, airspy
, hackrf
, libbladeRF
, rtl-sdr
, soapysdr-with-plugins
}:

let
  version = {
    "3.7" = "0.1.5";
    "3.8" = "0.2.2";
    "3.9" = null;
  }.${gnuradio.versionAttr.major};
  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "v${version}";
    sha256 = {
      "3.7" = "0bf9bnc1c3c4yqqqgmg3nhygj6rcfmyk6pybi27f7461d2cw1drv";
      "3.8" = "HT6xlN6cJAnvF+s1g2I1uENhBJJizdADlLXeSD0rEqs=";
      "3.9" = null;
    }.${gnuradio.versionAttr.major};
  };
in mkDerivation {
  pname = "gr-osmosdr";
  inherit version src;
  disabledForGRafter = "3.9";

  buildInputs = [
    log4cpp
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
  ] ++ lib.optional (gnuradio.hasFeature "gr-uhd" gnuradio.features) [
    uhd
  ];
  cmakeFlags = [
    (if (gnuradio.hasFeature "python-support" gnuradio.features) then
      "-DENABLE_PYTHON=ON"
    else
      "-DENABLE_PYTHON=OFF"
    )
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    swig
  ] ++ lib.optionals (gnuradio.hasFeature "python-support" gnuradio.features) [
      (if (gnuradio.versionAttr.major == "3.7") then
        python.pkgs.cheetah
      else
        python.pkgs.Mako
      )
      python
    ]
  ;

  meta = with lib; {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
