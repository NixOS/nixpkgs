{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a8ec019d9b330a6a6f69a7de61d14b4c98b102d76359047c5ce0263e12246a6";
  };

  # Some tests require physical probing and additional physical setup
  doCheck = false;

  meta = {
    homepage = "https://github.com/vsergeev/python-periphery";
    description = "Linux Peripheral I/O (GPIO, LED, PWM, SPI, I2C, MMIO, Serial) with Python 2 & 3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bandresen ];
  };
}
