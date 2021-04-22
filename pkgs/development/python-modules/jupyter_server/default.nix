{ lib
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
, requests
}:

buildPythonPackage rec {
  pname = "jupyter_server";
  version = "1.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff127713a57ab7aa7b23f7df9b082951cc4b05d8d64cc0949d01ea02ac24c70c";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "anyio>=2.0.2" "anyio"
  '';

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
  ];

  meta = with lib; {
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications.";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.elohmeier ];
  };
}
