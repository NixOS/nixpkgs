{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.54.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vL8jSgTtDvaHuCvaCYmFixILQFasTl82yINL5yRtOwU=";
  };

  propagatedBuildInputs = [
    pyserial
    pyusb
  ];

  # Tests require access to the serial port
  doCheck = false;

  pythonImportsCheck = [
    "pyftdi"
  ];

  meta = with lib; {
    description = "User-space driver for modern FTDI devices";
    longDescription = ''
      PyFtdi aims at providing a user-space driver for popular FTDI devices.
      This includes UART, GPIO and multi-serial protocols (SPI, I2C, JTAG)
      bridges.
    '';
    homepage = "https://github.com/eblot/pyftdi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
