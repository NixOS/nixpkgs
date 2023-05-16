{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatch-jupyter-builder
, hatchling
, pandoc
, pytestCheckHook
, pytest-console-scripts
, pytest-jupyter
, pytest-timeout
, pytest-tornasync
, argon2-cffi
, jinja2
, tornado
, pyzmq
, ipykernel
<<<<<<< HEAD
=======
, ipython_genutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, traitlets
, jupyter-core
, jupyter-client
, jupyter-events
, jupyter-server-terminals
, nbformat
, nbconvert
<<<<<<< HEAD
, packaging
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, send2trash
, terminado
, prometheus-client
, anyio
, websocket-client
<<<<<<< HEAD
, overrides
, requests
, flaky
=======
, requests
, requests-unixsocket
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jupyter-server";
<<<<<<< HEAD
  version = "2.7.3";
  format = "pyproject";
  disabled = pythonOlder "3.8";
=======
  version = "2.0.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "jupyter_server";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-1JFshYHE67xTTOvaqOyiR42fO/3Yjq4p/KsBIOrFdkk=";
=======
    hash= "sha256-jddZkukLfKVWeUoe1cylEmPGl6vG0N9WGvV0qhwKAz8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
  ];

  propagatedBuildInputs = [
    argon2-cffi
    jinja2
    tornado
    pyzmq
<<<<<<< HEAD
=======
    ipython_genutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    traitlets
    jupyter-core
    jupyter-client
    jupyter-events
    jupyter-server-terminals
    nbformat
    nbconvert
<<<<<<< HEAD
    packaging
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    send2trash
    terminado
    prometheus-client
    anyio
    websocket-client
<<<<<<< HEAD
    overrides
=======
    requests-unixsocket
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    ipykernel
<<<<<<< HEAD
=======
    pandoc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
    pytest-console-scripts
    pytest-jupyter
    pytest-timeout
<<<<<<< HEAD
    requests
    flaky
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
=======
    pytest-tornasync
    requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
<<<<<<< HEAD
    "test_server_extension_list"
    "test_cull_idle"
    "test_server_extension_list"
=======
    "test_cull_idle"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    # attempts to use trashcan, build env doesn't allow this
    "test_delete"
    # test is presumable broken in sandbox
    "test_authorized_requests"
<<<<<<< HEAD
    # Insufficient access privileges for operation
    "test_regression_is_hidden"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    "test_copy_big_dir"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTestPaths = [
    "tests/services/kernels/test_api.py"
    "tests/services/sessions/test_api.py"
    # nbconvert failed: `relax_add_props` kwargs of validate has been
    # deprecated for security reasons, and will be removed soon.
    "tests/nbconvert/test_handlers.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/jupyter-server/jupyter_server/blob/v${version}/CHANGELOG.md";
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = lib.teams.jupyter.members;
=======
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.elohmeier ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
