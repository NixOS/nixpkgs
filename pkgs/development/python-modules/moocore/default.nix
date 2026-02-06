{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cffi,
  setuptools,

  # dependencies
  numpy,
  platformdirs,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "moocore";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "multi-objective";
    repo = "moocore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0UA06no7pZd+8WQIUUrB5u87T3PoPv7dldBChEh4bw=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [
    cffi
    setuptools
  ];

  dependencies = [
    cffi
    numpy
    platformdirs
  ];

  pythonImportsCheck = [ "moocore" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Require downloading data from the internet
    "test_read_datasets_data"
  ];

  meta = {
    description = "Core Mathematical Functions for Multi-Objective Optimization";
    homepage = "https://github.com/multi-objective/moocore/tree/main/python";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
