{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, quantities
, pythonOlder
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LUIYsIJtruqIDhVSJwYAKew4oAI4zrXwlxONlGfGOZs=";
  };

  propagatedBuildInputs = [
    numpy
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
