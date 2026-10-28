{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pyusb,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyftdi";
  version = "0.57.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eblot";
    repo = "pyftdi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v6WcDwKVnLB2SwWiKG0VYg1VTyaSDz0QvG3hAQs7YHI=";
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
    changelog = "https://github.com/eblot/pyftdi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
