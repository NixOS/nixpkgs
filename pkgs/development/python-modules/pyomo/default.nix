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
<<<<<<< HEAD
  version = "6.9.5";
=======
  version = "6.9.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-DHA/OukSK1p65imJEZg7hbErJGL7aQiDbW4vUUuSEko=";
=======
    hash = "sha256-iH6vxxA/CdPCXqiw3BUmhUwhS2hfwaJy5jIic4id0Jw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python Optimization Modeling Objects";
    homepage = "http://www.pyomo.org/";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Python Optimization Modeling Objects";
    homepage = "http://www.pyomo.org/";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${src.tag}";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "pyomo";
  };
}
