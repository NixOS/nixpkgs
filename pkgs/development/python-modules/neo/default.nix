{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, packaging
, quantities
, pythonOlder
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9KIGBEszKtALEAcrDcenCzWfo2XseG+Sq3V+9K5YhHQ=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    quantities
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests --exclude=iotest
  '';

  pythonImportsCheck = [
    "neo"
  ];

  meta = with lib; {
    description = "Package for representing electrophysiology data";
    homepage = "https://neuralensemble.org/neo/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
