{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "Adafruit-PureIO";
  version = "1.1.8";

  src = fetchPypi {
    pname = "Adafruit_PureIO";
    inherit version;
    sha256 = "1mfa6sfz7qwgajz3lqw0s69ivvwbwvblwkjzbrwdrxjbma4jaw66";
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
