{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  param,
  pyyaml,
  requests,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyct";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3Z9KxcvY43w1LAQDYGLTxfZ+/sdtQEdh7xawy/JqpqA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    param
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  # Only the command line doesn't work on with Python 3.12, due to usage of
  # deprecated distutils module. Not disabling it totally.
  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    "pyct/tests/test_cmd.py"
  ];

  pythonImportsCheck = [ "pyct" ];

  meta = {
    description = "ClI for Python common tasks for users";
    mainProgram = "pyct";
    homepage = "https://github.com/pyviz/pyct";
    changelog = "https://github.com/pyviz-dev/pyct/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
