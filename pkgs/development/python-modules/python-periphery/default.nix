{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bhzkzjvz6zb6rc5zmvgqfszrcyh64v1hay7m1m5dn083gaznyk9";
  };

  # Some tests require physical probing and additional physical setup
  doCheck = false;

  meta = {
    homepage = https://github.com/vsergeev/python-periphery;
    description = "Linux Peripheral I/O (GPIO, LED, PWM, SPI, I2C, MMIO, Serial) with Python 2 & 3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bandresen ];
  };
}
