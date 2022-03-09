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
  version = "0.10.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RE/xUnjdz541d4IOh4z2ufQiDOFFvxATyPMFNs9gk5s=";
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
