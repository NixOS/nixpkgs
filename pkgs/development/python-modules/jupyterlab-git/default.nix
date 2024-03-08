{ lib
, buildPythonPackage
, fetchPypi
, git
, jupyter-server
, hatch-jupyter-builder
, hatch-nodejs-version
, hatchling
, jupyterlab
, nbdime
, nbformat
, pexpect
, pytest-asyncio
, pytest-jupyter
, pytest-tornasync
, pytestCheckHook
, pythonOlder
, traitlets
}:

buildPythonPackage rec {
  pname = "jupyterlab-git";
  version = "0.50.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyterlab_git";
    inherit version;
    hash = "sha256-CYWVRtOQE067kYqWXCw/4mBf6v4yfPYWFb592Qtb37s=";
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
    jupyter-server
    nbdime
    git
    nbformat
    pexpect
    traitlets
  ];

  nativeCheckInputs = [
    jupyterlab
    pytest-asyncio
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

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

  pythonImportsCheck = [
    "jupyterlab_git"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ chiroptical ];
  };
}
