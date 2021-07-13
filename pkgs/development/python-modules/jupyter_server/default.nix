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
, prometheus_client
, anyio
, websocket-client
, requests
}:

buildPythonPackage rec {
  pname = "jupyter_server";
  version = "1.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f0c75e0a577536125ad62a442ebb7cf02746f1a69d907e8a273c6225d281237";
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
    prometheus_client
    anyio
    websocket-client
  ];

  checkInputs = [
    pytestCheckHook
    pytest-tornasync
    requests
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [ "jupyter_server/tests/" ];

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
