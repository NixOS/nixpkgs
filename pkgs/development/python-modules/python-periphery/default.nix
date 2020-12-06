{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed07adc27c8b4df9cd40b2d935f86400a7b495b311df5bfaf9ecaeafc5413fd5";
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
