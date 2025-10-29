{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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

buildPythonPackage rec {
  pname = "jupyter-collaboration";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter-collaboration";
    tag = "v${version}";
    hash = "sha256-PnfUWtOXdXYG5qfzAW5kATSQr2sWKDBNiINA8/G4ZX4=";
  };

  sourceRoot = "${src.name}/projects/jupyter-collaboration";

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

  preCheck = ''
    appendToVar enabledTestPaths "$src/tests"
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
