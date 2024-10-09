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
  name = "gr-bladeRF";
  version = "unstable-2023-11-20";

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "gr-bladeRF";
    rev = "27de2898dbee75d55c61f541315e3853e602e526";
    hash = "sha256-josovHEp2VxgZqItkTAISdY1LARMIvQKD604fh4iZWc=";
  };

  buildInputs =
    [
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
    (if (gnuradio.hasFeature "python-support") then "-DENABLE_PYTHON=ON" else "-DENABLE_PYTHON=OFF")
  ];
  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals (gnuradio.hasFeature "python-support") [
      python.pkgs.mako
      python.pkgs.pygccxml
    ];

  meta = with lib; {
    description = "GNU Radio source and sink blocks for bladeRF devices";
    homepage = "https://github.com/Nuand/gr-bladeRF";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
  };
}
