{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, param
, pytestCheckHook
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "pyct";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3Z9KxcvY43w1LAQDYGLTxfZ+/sdtQEdh7xawy/JqpqA=";
  };

  propagatedBuildInputs = [
    param
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !isPy27;

  pythonImportsCheck = [
    "pyct"
  ];

  meta = with lib; {
    description = "ClI for Python common tasks for users";
    homepage = "https://github.com/pyviz/pyct";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
