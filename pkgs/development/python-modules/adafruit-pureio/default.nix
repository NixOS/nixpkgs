{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "adafruit-pureio";
  version = "1.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Adafruit_PureIO";
    inherit version;
    hash = "sha256-EgaIN1PAlmMJ5tAtqXBnbpvHtQO7Sib3NuAXOfVqZLk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Physical SMBus is not present
  doCheck = false;

  pythonImportsCheck = [
    "Adafruit_PureIO"
  ];

  meta = with lib; {
    description = "Python interface to Linux IO including I2C and SPI";
    homepage = "https://github.com/adafruit/Adafruit_Python_PureIO";
    changelog = "https://github.com/adafruit/Adafruit_Python_PureIO/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
