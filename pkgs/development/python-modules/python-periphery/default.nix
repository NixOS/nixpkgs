{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "2.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YdRh1zaYKm92boeHIKsQpoFR4ujBCGYA2TiaxH5A6Io=";
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
