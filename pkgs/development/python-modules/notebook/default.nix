{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchPypi
<<<<<<< HEAD
, hatch-jupyter-builder
, hatchling
, jupyter-server
, jupyterlab
, jupyterlab_server
, notebook-shim
, tornado
, pytest-jupyter
=======
, argon2-cffi
, glibcLocales
, mock
, jinja2
, tornado
, ipython_genutils
, traitlets
, jupyter-core
, jupyter-client
, nbformat
, nbclassic
, nbconvert
, ipykernel
, terminado
, requests
, send2trash
, pexpect
, prometheus-client
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "notebook";
<<<<<<< HEAD
  version = "7.0.2";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1w1qB0GMgpvV9UM3zpk7cQUmHZAm+dP+aOm4qhog2po=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "timeout = 300" ""
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
    jupyter-server
    jupyterlab
    jupyterlab_server
    notebook-shim
    tornado
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  env = {
    JUPYTER_PLATFORM_DIRS = 1;
  };

=======
  version = "6.5.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wYl+UxfiJfx4tFVJpqtLZo5MmW/QOgTpOP5eevK//9A=";
  };

  LC_ALL = "en_US.utf8";

  nativeCheckInputs = [ pytestCheckHook glibcLocales ];

  propagatedBuildInputs = [
    jinja2
    tornado
    ipython_genutils
    traitlets
    jupyter-core
    send2trash
    jupyter-client
    nbformat
    nbclassic
    nbconvert
    ipykernel
    terminado
    requests
    pexpect
    prometheus-client
    argon2-cffi
  ];

  postPatch = ''
    # Remove selenium tests
    rm -rf notebook/tests/selenium
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # a "system_config" is generated, and fails many tests
    "config"
    "load_ordered"
    # requires jupyter, but will cause circular imports
    "test_run"
    "TestInstallServerExtension"
    "launch_socket"
    "sock_server"
    "test_list_formats" # tries to find python MIME type
    "KernelCullingTest" # has a race condition failing on slower hardware
    "test_connections" # tornado.simple_httpclient.HTTPTimeoutError: Timeout during request"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_delete"
    "test_checkpoints_follow_file"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # requires local networking
    "notebook/auth/tests/test_login.py"
    "notebook/bundler/tests/test_bundler_api.py"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/jupyter/notebook/blob/v${version}/CHANGELOG.md";
    description = "Web-based notebook environment for interactive computing";
    homepage = "https://github.com/jupyter/notebook";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
=======
    description = "The Jupyter HTML notebook is a web-based notebook environment for interactive computing";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "jupyter-notebook";
  };
}
