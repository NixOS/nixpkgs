{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  jupyter-collaboration-ui,
  jupyter-docprovider,
  jupyter-server-ydoc,
  jupyterlab,

  # tests
  dirty-equals,
  httpx-ws,
  pytest-jupyter,
  pytest-timeout,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-collaboration";
  version = "5.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter-collaboration";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gho8ndF8SU1AWJUlcuw2a/kHD2zu7vH/z4QV8drDrP0=";
  };

  sourceRoot = "${finalAttrs.src.name}/projects/jupyter-collaboration";

  build-system = [ hatchling ];

  dependencies = [
    jupyter-collaboration-ui
    jupyter-docprovider
    jupyter-server-ydoc
    jupyterlab
  ];

  pythonImportsCheck = [ "jupyter_collaboration" ];

  nativeCheckInputs = [
    dirty-equals
    httpx-ws
    pytest-jupyter
    pytest-timeout
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # pytest.PytestCacheWarning: could not create cache path /build/source/.pytest_cache/v/cache/nodeids: [Errno 13] Permission denied: '/build/source/pytest-cache-files-plraagdr'
    "-pno:cacheprovider"
  ];

  enabledTestPaths = [
    "../../tests"
  ];

  disabledTests = [
    # Failed: Timeout (>300.0s) from pytest-timeout
    "test_document_ttl_from_settings"
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    # pytest.PytestUnraisableExceptionWarning: Exception ignored in: None
    "test_dirty"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
