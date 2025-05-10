{
  lib,
  buildPythonPackage,
  fetchPypi,
  git,
  writableTmpDirAsHomeHook,
  jupyter-server,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,
  nbdime,
  nbformat,
  packaging,
  pexpect,
  pytest-asyncio,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyterlab-git";
  version = "0.51.1";
  pyproject = true;


  src = fetchPypi {
    pname = "jupyterlab_git";
    inherit version;
    hash = "sha256-t7zol5XVzojIqvDXnrepPQU1Yi+b5rAZyprk07mpymo=";
  };

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  dependencies = [
    jupyter-server
    nbdime
    nbformat
    packaging
    pexpect
    traitlets
  ];

  propagatedBuildInputs = [ git ];

  nativeCheckInputs = [
    jupyterlab
    pytest-asyncio
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "jupyterlab_git/tests/test_handlers.py"
    # PyPI doesn't ship all required files for the tests
    "jupyterlab_git/tests/test_config.py"
    "jupyterlab_git/tests/test_integrations.py"
    "jupyterlab_git/tests/test_remote.py"
    "jupyterlab_git/tests/test_settings.py"
  ];

  disabledTests = [
    "test_Git_get_nbdiff_file"
    "test_Git_get_nbdiff_dict"
  ];

  pythonImportsCheck = [ "jupyterlab_git" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ chiroptical ];
  };
}
