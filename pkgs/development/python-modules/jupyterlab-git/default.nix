{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, git
, jupyter_server
, jupyter-packaging
, jupyterlab
, nbdime
, nbformat
, pexpect
, pytest-asyncio
, pytest-tornasync
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyterlab-git";
  version = "0.41.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "jupyterlab_git";
    inherit version;
    sha256 = "sha256-UXZ9qgAvCKfPCzchFOtwbv8vNPEtcLU0dwBGTmiHSD4=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  propagatedBuildInputs = [
    jupyter_server
    nbdime
    git
    nbformat
    pexpect
  ];

  checkInputs = [
    jupyterlab
    pytest-asyncio
    pytest-tornasync
    pytestCheckHook
  ];

  # All Tests on darwin fail or are skipped due to sandbox
  doCheck = !stdenv.isDarwin;

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

  meta = with lib; {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ chiroptical ];
  };
}
