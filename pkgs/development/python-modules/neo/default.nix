{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, quantities
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n74miad4dadavnzi1hqlyzyk795x7qq2adp71i011534ixs70ik";
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
