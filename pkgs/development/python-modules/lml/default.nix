{ lib
, buildPythonPackage
, fetchPypi
, nose
, mock
}:

buildPythonPackage rec {
  pname = "lml";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57a085a29bb7991d70d41c6c3144c560a8e35b4c1030ffb36d85fa058773bcc5";
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
