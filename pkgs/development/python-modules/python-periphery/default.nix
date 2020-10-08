{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57baa82e6bc59b67747317d16ad0cf9626826e8d43233af13bce924660500bd6";
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
