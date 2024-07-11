{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pythonOlder,
  pyusb,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.55.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = "pyftdi";
    rev = "refs/tags/v${version}";
    hash = "sha256-InJJnbAPYlV071EkEWECJC79HLZ6SWo2VP7PqMgOGow=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    pyusb
  ];

  # Tests require access to the serial port
  doCheck = false;

  pythonImportsCheck = [ "pyftdi" ];

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
