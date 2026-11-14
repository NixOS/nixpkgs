{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  deprecated,
  networkx,
  numpy,
  scipy,

  # tests
  hypothesis,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "nashpy";
  version = "0.0.43";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "drvinceknight";
    repo = "Nashpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u7is2/z2l5R6X6VQk/hR5wYwCkCgwB2wFcerYfJZ6aM=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    deprecated
    networkx
    numpy
    scipy
  ];

  pythonImportsCheck = [ "nashpy" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests" ];

  meta = {
    description = "Python library for 2 player games";
    homepage = "https://github.com/drvinceknight/Nashpy";
    changelog = "https://github.com/drvinceknight/Nashpy/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
