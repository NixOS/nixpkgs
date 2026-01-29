{
  lib,
  mkDerivation,
  gnuradioAtLeast,
  fetchgit,
  gnuradio,

  # native
  cmake,
  pkg-config,

  # buildInputs
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
  features ? { },
}:

mkDerivation (finalAttrs: {
  pname = "gr-osmosdr";
  version = "0.2.6";

  src = fetchgit {
    url = "https://gitea.osmocom.org/sdr/gr-osmosdr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jCUzBY1pYiEtcRQ97t9F6uEMVYw2NU0eoB5Xc2H6pGQ=";
  };

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
  ]
  ++ finalAttrs.finalPackage.passthru.enabledFeaturesDeps
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
  ]
  ++ finalAttrs.finalPackage.passthru.enabledFeaturesCmakeFlags;
  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.mako
    python
  ];
  passthru = {
    featuresDeps = {
      # Other features don't have dependencies but can still be disabled in the
      # `features` argument.
      airspy = [ airspy ];
      bladerf = [ libbladeRF ];
      hackrf = [ hackrf ];
      rtl = [ rtl-sdr ];
      soapy = [ soapysdr-with-plugins ];
    };
    enabledFeaturesDeps = lib.pipe finalAttrs.finalPackage.passthru.featuresDeps [
      (lib.filterAttrs (name: deps: features.${name} or true))
      lib.attrValues
      lib.flatten
    ];
    enabledFeaturesCmakeFlags = lib.mapAttrsToList (
      feat: val: lib.cmakeBool "ENABLE_${lib.toUpper feat}" val
    ) features;
  };

  meta = {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = "https://sdr.osmocom.org/trac/wiki/GrOsmoSDR";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.unix;
  };
})
