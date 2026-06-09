{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  parameterized,
  ply,
  pybind11,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pyomo";
  version = "6.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    tag = version;
    hash = "sha256-DHA/OukSK1p65imJEZg7hbErJGL7aQiDbW4vUUuSEko=";
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

  meta = {
    description = "Python Optimization Modeling Objects";
    homepage = "http://www.pyomo.org/";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "pyomo";
  };
}
