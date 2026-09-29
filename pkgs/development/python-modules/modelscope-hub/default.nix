{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tqdm,
  filelock,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-mock,
  responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "modelscope-hub";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope_hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8q4Oz8WGVavrS1afolr8DYR7ATQSzssCgZpp+bdxbng=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    tqdm
  ];

  disabledTestPaths = [
    # Fail with `AssertionError`s, see:
    # https://github.com/modelscope/modelscope_hub/issues/46
    "tests/cli/test_mcp.py::TestMcpDeployExecute::test_deploy"
    "tests/test_utils.py::TestParseTimestamp::test_datetime_passthrough"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    responses
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "modelscope_hub" ];

  meta = {
    description = "Python client for the ModelScope Hub";
    homepage = "https://github.com/modelscope/modelscope_hub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
