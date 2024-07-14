{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pmsensor";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f8A6r7eRynDYR8mrl88YG8fY9zRe+0sMP2bAe5x97mk=";
  };

  propagatedBuildInputs = [ pyserial ];

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
