{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-periphery";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe8f351934edce72cd919b4eb070878ebff551db5e21aea61e0f446101f0a79f";
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
