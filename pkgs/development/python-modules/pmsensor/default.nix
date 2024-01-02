{ lib
, buildPythonPackage
, fetchPypi
, pyserial
}:

buildPythonPackage rec {
  pname = "pmsensor";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fc03aafb791ca70d847c9ab97cf181bc7d8f7345efb4b0c3f66c07b9c7dee69";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pmsensor.co2sensor"
    "pmsensor.serial_pm"
  ];

  meta = with lib; {
    description = "Library to read data from environment sensors";
    homepage = "https://github.com/open-homeautomation/pmsensor";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
