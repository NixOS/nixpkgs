{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  google-re2,
  jmespath,
  lark,
  pendulum,
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cel-python";
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cloud-custodian";
    repo = "cel-python";
    tag = "v${lib.versions.majorMinor finalAttrs.version}";
    hash = "sha256-DPHgHRvzQnBzjl2y9yNWt330xF535dO0iBObuqlr+PI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    google-re2
    jmespath
    lark
    pendulum
    pyyaml
  ];

  pythonImportsCheck = [ "celpy" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests"
  ];

  disabledTestPaths = [
    # Require cloud-custodian (c7n)
    "tests/test_c7n_to_cel.py"
    "tests/test_c7nlib.py"
  ];

  meta = {
    description = "Pure Python implementation of the Common Expression Language";
    homepage = "https://github.com/cloud-custodian/cel-python";
    changelog = "https://github.com/cloud-custodian/cel-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
