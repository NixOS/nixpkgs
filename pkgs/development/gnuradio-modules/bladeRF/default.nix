{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  doxygen,
  gmp,
  gnuradio,
  libbladeRF,
  mpir,
  osmosdr,
  python,
  spdlog,
}:

mkDerivation {
  pname = "gr-bladeRF";
  version = "0-unstable-2023-11-20";

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "gr-bladeRF";
    rev = "27de2898dbee75d55c61f541315e3853e602e526";
    hash = "sha256-josovHEp2VxgZqItkTAISdY1LARMIvQKD604fh4iZWc=";
  };

  buildInputs = [
    boost
    doxygen
    gmp
    gnuradio
    libbladeRF
    mpir
    osmosdr
    spdlog
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.numpy
    python.pkgs.pybind11
  ];
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_PYTHON" (gnuradio.hasFeature "python-support"))
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.mako
    python.pkgs.pygccxml
  ];

  meta = {
    description = "GNU Radio source and sink blocks for bladeRF devices";
    homepage = "https://github.com/Nuand/gr-bladeRF";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.linux;
  };
}
