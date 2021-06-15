{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, quantities
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e31c88d7c52174fa2512df589b2b5003e9471fde27fca9f315f4770ba3bd3cb";
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
