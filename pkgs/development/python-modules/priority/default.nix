{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "priority";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "priority" ];

  meta = with lib; {
    description = "Python implementation of the HTTP/2 priority tree";
    homepage = "https://python-hyper.org/priority/";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss ];
  };
}
