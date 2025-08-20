{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-git,
  numpy,
  pillow,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "daltonlens";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T7fXlRdFtcVw5WURPqZhCmulUi1ZnCfCXgcLtTHeNas=";
  };

  build-system = [
    setuptools
    setuptools-git
  ];

  dependencies = [
    numpy
    pillow
  ];

  pythonImportsCheck = [
    "daltonlens"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTestPaths = [
    "tests/test_generate.py"
  ];

  meta = {
    description = "R&D companion package for the desktop application DaltonLens";
    homepage = "https://github.com/DaltonLens/DaltonLens-Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
