{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, pytest-tornasync
, argon2_cffi
, jinja2
, tornado
, pyzmq
, ipython_genutils
, traitlets
, jupyter_core
, jupyter_client
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
  version = "1.11.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-irT0hKSiaY91fP8HadJ7XZkeAjKmZtVPTWraTmphMws=";
  };

  propagatedBuildInputs = [
    argon2_cffi
    jinja2
    tornado
    pyzmq
    ipython_genutils
    traitlets
    jupyter_core
    jupyter_client
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
    pytestCheckHook
    pytest-tornasync
    requests
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
  '';

  pytestFlagsArray = [ "jupyter_server" ];

  # disabled failing tests
  disabledTests = [
    "test_server_extension_list"
    "test_list_formats"
    "test_base_url"
    "test_culling"
  ] ++ lib.optionals stdenv.isDarwin [
    # attempts to use trashcan, build env doesn't allow this
    "test_delete"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.elohmeier ];
  };
}
