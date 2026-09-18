{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "setup_requires = setuptools_git" ""
  '';

  build-system = [
    setuptools
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

  enabledTestPaths = [
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
