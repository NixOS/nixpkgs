{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "quixote";
  version = "3.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F4u50xz6sNwBIzgEglVnwKTKxguE6f1m9Y2DAUEJsGQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "quixote" ];

  disabledTestPaths = [
    # Test has additional requirements
    "quixote/ptl/test/test_ptl.py"
  ];

  meta = with lib; {
    description = "Small and flexible Python Web application framework";
    homepage = "https://pypi.org/project/Quixote/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
