{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v0qpv0i2kqhjvl6wvvvy29hazjdcym7nn14qzv4r5zq1zsdb92x";
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
