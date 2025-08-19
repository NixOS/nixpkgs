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
  version = "unstable-2025-01-09";

  src = fetchFromGitHub {
    owner = "tapparelj";
    repo = "gr-lora_sdr";
    rev = "9befbad3e6120529918acf1a742e25465f6b95e4";
    hash = "sha256-9oBdzoS2aWWXmiUk5rI0gG3g+BJqUDgMu3/PmZSUkuU=";
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
