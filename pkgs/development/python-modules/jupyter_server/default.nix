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
}:

buildPythonPackage rec {
  pname = "jupyter_server";
  version = "1.10.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3a3b68ebc6d7bfee1097f1712cf7709ee39c92379da2cc08724515bb85e72bf";
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
