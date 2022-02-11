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
  version = "0.10.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lw3r9p1ky1cswhrs9radc0vq1qfzbrk7qd00f34g96g30zab4g5";
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
