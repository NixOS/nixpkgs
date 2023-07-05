{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "adafruit-pureio";
  version = "1.1.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Adafruit_PureIO";
    inherit version;
    hash = "sha256-xM+7NlcxlC0fEJKhFvR9/a4K7xjFsn8QcrWCStXqjHw=";
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
