{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "quixote";
  version = "3.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+7RMcIG4J8CwyqY37BCaQNJlXgHTAYCda64IAMEdRjQ=";
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
})
