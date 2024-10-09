{ lib
, python3Packages
, fetchFromGitHub
}:

with python3Packages; buildPythonApplication rec {
  pname = "tinyprog";
  # `python setup.py --version` from repo checkout
  version = "1.0.24.dev114+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "tinyfpga";
    repo = "TinyFPGA-Bootloader";
    rev = "97f6353540bf7c0d27f5612f202b48f41da75299";
    sha256 = "0zbrvvb957z2lwbfd39ixqdsnd2w4wfjirwkqdrqm27bjz308731";
  };

  sourceRoot = "${src.name}/programmer";

  propagatedBuildInputs = [
    pyserial
    jsonmerge
    intelhex
    tqdm
    six
    packaging
    setuptools
    pyusb
  ];

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    homepage = "https://github.com/tinyfpga/TinyFPGA-Bootloader/tree/master/programmer";
    description = "Programmer for FPGA boards using the TinyFPGA USB Bootloader";
    mainProgram = "tinyprog";
    maintainers = [ ];
    license = licenses.asl20;
  };
}
