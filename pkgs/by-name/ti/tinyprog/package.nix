{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "tinyprog";
  # `python setup.py --version` from repo checkout
  version = "1.0.24.dev114+g${lib.substring 0 7 src.rev}";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinyfpga";
    repo = "TinyFPGA-Bootloader";
    rev = "97f6353540bf7c0d27f5612f202b48f41da75299";
    hash = "sha256-YRwExpfriIpzw5PnKB0nXDSrG+4xjeYWp+KfktbeeX0=";
  };

  sourceRoot = "${src.name}/programmer";

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyserial
    jsonmerge
    intelhex
    tqdm
    six
    packaging
    setuptools # pkg_resources is imported during runtime
    pyusb
  ];

  meta = {
    homepage = "https://github.com/tinyfpga/TinyFPGA-Bootloader/tree/master/programmer";
    description = "Programmer for FPGA boards using the TinyFPGA USB Bootloader";
    mainProgram = "tinyprog";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
