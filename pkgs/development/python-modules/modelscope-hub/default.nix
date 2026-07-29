{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  tqdm,
  filelock,
  urllib3,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-mock,
  responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "modelscope-hub";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope_hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SYMgQGKBV+VzncDtQSCekDRfnLMUenbNbE2qGtAOO8w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    requests
    tqdm
    urllib3
  ];

  disabledTests = [
    # datetime identity check (is) — always fails upstream
    "test_datetime_passthrough"
  ];

  pytestFlags = [
    # deploy/undeploy use different call signature in this version
    "--deselect=tests/cli/test_mcp.py::TestMcpDeployExecute::test_deploy"
    "--deselect=tests/cli/test_mcp.py::TestMcpUndeployExecute::test_undeploy"
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
    maintainers = with lib.maintainers; [ kyehn ];
  };
})
