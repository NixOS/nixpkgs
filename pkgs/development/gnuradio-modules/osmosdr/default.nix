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
, thrift
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
    "3.8" = "0.2.3";
  }.${gnuradio.versionAttr.major};
  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "v${version}";
    sha256 = {
      "3.7" = "0bf9bnc1c3c4yqqqgmg3nhygj6rcfmyk6pybi27f7461d2cw1drv";
      "3.8" = "sha256-ZfI8MshhZOdJ1U5FlnZKXsg2Rsvb6oKg943ZVYd/IWo=";
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
  ] ++ lib.optionals (gnuradio.hasFeature "gr-uhd") [
    uhd
  ] ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    python.pkgs.thrift
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
    swig
  ] ++ lib.optionals (gnuradio.hasFeature "python-support") [
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
