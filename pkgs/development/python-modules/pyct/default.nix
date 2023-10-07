{ lib
, buildPythonPackage
, fetchPypi
, param
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "pyct";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3Z9KxcvY43w1LAQDYGLTxfZ+/sdtQEdh7xawy/JqpqA=";
  };

  propagatedBuildInputs = [
    param
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyct"
  ];

  meta = with lib; {
    description = "ClI for Python common tasks for users";
    homepage = "https://github.com/pyviz/pyct";
    changelog = "https://github.com/pyviz-dev/pyct/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
