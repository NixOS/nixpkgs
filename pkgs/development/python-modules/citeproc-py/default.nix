{
  lib,
  buildPythonPackage,
  citeproc-py-styles,
  fetchPypi,
  gitMinimal,
  jsonschema,
  lxml,
  pytestCheckHook,
  rnc2rng,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "citeproc-py";
  version = "0.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "citeproc_py";
    inherit version;
    hash = "sha256-uWkzyTiu4G/3RZDN9ouuZXwE4vsp1s0uaTqg2X3je8I=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  buildInputs = [ rnc2rng ];

  dependencies = [ lxml ];

  nativeCheckInputs = [
    citeproc-py-styles
    gitMinimal
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [ "citeproc" ];

  disabledTestPaths = [
    # FileNotFoundError: [Errno 2] No such file or directory
    "citeproc/data/schema/tests/schemas/input/test_json.py"
  ];

  meta = {
    description = "Citation Style Language (CSL) parser for Python";
    homepage = "https://github.com/citeproc-py/citeproc-py";
    changelog = "https://github.com/citeproc-py/citeproc-py/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "csl_unsorted";
  };
}
