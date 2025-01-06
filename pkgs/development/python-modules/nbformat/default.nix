{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchPypi,
  hatchling,
  hatch-nodejs-version,
  fastjsonschema,
  jsonschema,
  jupyter-core,
  traitlets,
  pep440,
  pytestCheckHook,
  testpath,
}:

buildPythonPackage rec {
  pname = "nbformat";
  version = "5.10.4";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MiFosU+Tel0RNimI7KwqSVLT2OOiy+sjGVhGMSJtWzo=";
  };

  build-system = [
    hatchling
    hatch-nodejs-version
  ];

  dependencies = [
    fastjsonschema
    jsonschema
    jupyter-core
    traitlets
  ];

  pythonImportsCheck = [ "nbformat" ];

  nativeCheckInputs = [
    pep440
    pytestCheckHook
    testpath
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.13") [
    # ResourceWarning: unclosed database in <sqlite3.Connection object at 0x7ffff54954e0>
    "tests/test_validator.py"
    "tests/v4/test_convert.py"
    "tests/v4/test_json.py"
    "tests/v4/test_validate.py"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jupyter Notebook format";
    mainProgram = "jupyter-trust";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ globin ];
  };
}
