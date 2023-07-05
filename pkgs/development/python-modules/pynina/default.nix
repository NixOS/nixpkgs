{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynina";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyNINA";
    inherit version;
    hash = "sha256-5+Mg3dPjMxEL2pgEeuR1TwiicIMHN6RO6G0SgbZm/eM=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pynina"
  ];

  meta = with lib; {
    description = "Python API wrapper to retrieve warnings from the german NINA app";
    homepage = "https://gitlab.com/DeerMaximum/pynina";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
