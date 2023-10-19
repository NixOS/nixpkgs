{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kj5eL2nBVfLMQtr7vXDhbj/eJNLUqiq3L744YjiJJGI=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "blinker" ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/blinker/";
    description = "Fast, simple object-to-object and broadcast signaling";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
