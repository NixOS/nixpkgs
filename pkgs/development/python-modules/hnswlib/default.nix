{
  buildPythonPackage,
  hnswlib,
  numpy,
  pybind11,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage {
  pname = "hnswlib";
  inherit (hnswlib) version src meta;
  pyproject = true;

  nativeBuildInputs = [
    numpy
    setuptools
    pybind11
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "tests/python"
    "--pattern 'bindings_test*.py'"
  ];

  pythonImportsCheck = [ "hnswlib" ];
}
