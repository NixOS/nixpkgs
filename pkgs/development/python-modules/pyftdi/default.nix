{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pyusb,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyftdi";
  version = "0.57.1";
  pyproject = true;

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

  meta = {
    description = "User-space driver for modern FTDI devices";
    longDescription = ''
      PyFtdi aims at providing a user-space driver for popular FTDI devices.
      This includes UART, GPIO and multi-serial protocols (SPI, I2C, JTAG)
      bridges.
    '';
    homepage = "https://github.com/eblot/pyftdi";
    changelog = "https://github.com/eblot/pyftdi/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
