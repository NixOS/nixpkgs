{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyperframe";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9jCQigCFSnreq9Y4K0OSOkxM1Lgh/LUn5queFTgqOwg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyperframe" ];

  meta = with lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = "https://github.com/python-hyper/hyperframe/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
