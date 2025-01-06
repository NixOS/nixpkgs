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
  version = "3.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Quixote";
    inherit version;
    hash = "sha256-78t6tznI3+vIRkWNi0HDPGhR8aGaET3IMXQvmAPdSSY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "quixote" ];

  disabledTestPaths = [
    # Test has additional requirements
    "quixote/ptl/test/test_ptl.py"
  ];

  meta = {
    description = "Small and flexible Python Web application framework";
    homepage = "https://pypi.org/project/Quixote/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
