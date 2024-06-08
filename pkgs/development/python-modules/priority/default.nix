{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "priority";
  version = "2.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0";
  };

  pythonImportsCheck = [ "priority" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A pure-Python implementation of the HTTP/2 priority tree";
    homepage = "https://github.com/python-hyper/priority/";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss ];
  };
}
