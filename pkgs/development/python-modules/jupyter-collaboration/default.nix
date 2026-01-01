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
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "4.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyter-collaboration";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KXD5RRRh8cwZWZUpJrkS7RAfaeTjAHajKLl8c5MuhrA=";
=======
    hash = "sha256-/NFx76jqByPhzFKYFIcVctJv9+WQeuoUQaqNt+tUs8o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  disabledTests = [
    # Failed: Timeout (>300.0s) from pytest-timeout
    "test_document_ttl_from_settings"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "JupyterLab Extension enabling Real-Time Collaboration";
    homepage = "https://github.com/jupyterlab/jupyter_collaboration";
    changelog = "https://github.com/jupyterlab/jupyter_collaboration/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
