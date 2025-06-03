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
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter-collaboration";
    tag = "v${version}";
    hash = "sha256-BCvTtrlP45YC9G/m/e8Nvbls7AugIaQzO2Gect1EmGE=";
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

  pytestFlagsArray = [
    # pytest.PytestCacheWarning: could not create cache path /build/source/.pytest_cache/v/cache/nodeids: [Errno 13] Permission denied: '/build/source/pytest-cache-files-plraagdr'
    "-p"
    "no:cacheprovider"
    "$src/tests"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
