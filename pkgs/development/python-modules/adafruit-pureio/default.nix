{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "Adafruit-PureIO";
  version = "1.1.9";

  src = fetchPypi {
    pname = "Adafruit_PureIO";
    inherit version;
    sha256 = "0yd8hw676s7plq75gac4z0ilfcfydjkk3wv76bc73xy70zxj5brc";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # Physical SMBus is not present
  doCheck = false;
  pythonImportsCheck = [ "Adafruit_PureIO" ];

  meta = with lib; {
    description = "Python interface to Linux IO including I2C and SPI";
    homepage = "https://github.com/adafruit/Adafruit_Python_PureIO";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
