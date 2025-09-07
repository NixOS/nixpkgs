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
  version = "0.57.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "eblot";
    repo = "pyftdi";
    tag = "v${version}";
    hash = "sha256-RkZXcGvCZXmFrLvj7YqHc6FeZskEqMSQcYgizBSuwIk=";
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
    changelog = "https://github.com/eblot/pyftdi/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
