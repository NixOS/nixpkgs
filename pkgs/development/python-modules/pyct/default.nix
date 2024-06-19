{
  lib,
  buildPythonPackage,
  fetchPypi,
  param,
  pytestCheckHook,
  pythonAtLeast,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "pyct";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3Z9KxcvY43w1LAQDYGLTxfZ+/sdtQEdh7xawy/JqpqA=";
  };

  propagatedBuildInputs = [
    param
    pyyaml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyct" ];

  meta = with lib; {
    description = "ClI for Python common tasks for users";
    mainProgram = "pyct";
    homepage = "https://github.com/pyviz/pyct";
    changelog = "https://github.com/pyviz-dev/pyct/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
