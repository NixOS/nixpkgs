{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1arsibmc19iyzr70lqfrkq0fk6gd6imm3zxa7zxv93b6lwl5bw1d";
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
