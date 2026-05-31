{
  lib,
  mkDerivation,
  fetchFromGitHub,
  gnuradio,
  cmake,
  pkg-config,
  logLib,
  mpir,
  gmp,
  boost,
  python,
  gnuradioOlder,
}:

mkDerivation {
  pname = "gr-lora_sdr";
  version = "0-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "tapparelj";
    repo = "gr-lora_sdr";
    rev = "862746dd1cf635c9c8a4bfbaa2c3a0ec3a5306c9";
    hash = "sha256-12IqFNMLvqTN2R8+M9bXiteG4nQ8TwIMECSQPpgKCxM=";
  };
  disabled = gnuradioOlder "3.10";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    logLib
    mpir
    gmp
    boost
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.pybind11
    python.pkgs.numpy
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_PYTHON" (gnuradio.hasFeature "python-support"))
  ];

  meta = {
    description = "Fully-functional GNU Radio software-defined radio (SDR) implementation of a LoRa transceiver";
    homepage = "https://www.epfl.ch/labs/tcl/resources-and-sw/lora-phy/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.unix;
  };
}
