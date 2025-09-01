{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  parameterized,
  ply,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pyomo";
  version = "6.9.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    tag = version;
    hash = "sha256-lKjxPYlVCRew1SHYvehcGWKlLz6DsCG9Bocg6G+491c=";
  };

  build-system = [
    cython
    pybind11
    setuptools
  ];

  dependencies = [ ply ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pyomo" ];

  disabledTestPaths = [
    # Don't test the documentation and the examples
    "doc/"
    "examples/"
    # Tests don't work properly in the sandbox
    "pyomo/environ/tests/test_environ.py"
  ];

  disabledTests = [
    # Test requires lsb_release
    "test_get_os_version"
  ];

  meta = with lib; {
    description = "Python Optimization Modeling Objects";
    homepage = "http://www.pyomo.org/";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "pyomo";
  };
}
