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
    hash = "sha256-yWXVTxuNDQsZR52zkkx8Ns9nLb8q7JLUP72vRJK6GMA=";
  };

  pythonImportsCheck = [ "priority" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pure-Python implementation of the HTTP/2 priority tree";
    homepage = "https://github.com/python-hyper/priority/";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss ];
  };
}
