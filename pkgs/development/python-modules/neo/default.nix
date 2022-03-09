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
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LUIYsIJtruqIDhVSJwYAKew4oAI4zrXwlxONlGfGOZs=";
  };

  propagatedBuildInputs = [ numpy quantities ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests --exclude=iotest
  '';

  meta = with lib; {
    homepage = "https://neuralensemble.org/neo/";
    description = "Package for representing electrophysiology data in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
