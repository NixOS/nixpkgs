{ lib
, buildPythonPackage
, fetchPypi
, nose
, mock
}:

buildPythonPackage rec {
  pname = "lml";
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6luoF7Styen1whclzSR1+RKTO34t/fB5Ku2AB3FU9j8=";
  };

  checkInputs = [
    nose
    mock
  ];

  checkPhase = "nosetests";

  meta = {
    description = "Load me later. A lazy plugin management system for Python";
    homepage = "http://lml.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
