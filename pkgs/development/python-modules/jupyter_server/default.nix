{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pandoc
, pytestCheckHook
, pytest-console-scripts
, pytest-timeout
, pytest-tornasync
, argon2-cffi
, jinja2
, tornado
, pyzmq
, ipykernel
, ipython_genutils
, traitlets
, jupyter_core
, jupyter-client
, nbformat
, nbconvert
, send2trash
, terminado
, prometheus-client
, anyio
, websocket-client
, requests
, requests-unixsocket
}:

buildPythonPackage rec {
  pname = "jupyter_server";
  version = "1.17.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a36781656645ae17b12819a49ace377c045bf633823b3e4cd4b0c88c01e7711b";
  };

  propagatedBuildInputs = [
    argon2-cffi
    jinja2
    tornado
    pyzmq
    ipython_genutils
    traitlets
    jupyter_core
    jupyter-client
    nbformat
    nbconvert
    send2trash
    terminado
    prometheus-client
    anyio
    websocket-client
    requests-unixsocket
  ];

  checkInputs = [
    ipykernel
    pandoc
    pytestCheckHook
    pytest-console-scripts
    pytest-timeout
    pytest-tornasync
    requests
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    "test_cull_idle"
  ] ++ lib.optionals stdenv.isDarwin [
    # attempts to use trashcan, build env doesn't allow this
    "test_delete"
    # test is presumable broken in sandbox
    "test_authorized_requests"
  ];

  disabledTestPaths = [
    "tests/services/kernels/test_api.py"
    "tests/services/sessions/test_api.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.elohmeier ];
  };
}
