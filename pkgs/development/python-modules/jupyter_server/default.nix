{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, pytest-tornasync
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
  version = "1.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sBJvI39nlTPuxGJEz8ZtYeOh+OwPrS1HNS+hnT51Tkc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "anyio>=2.0.2" "anyio"
  '';

  propagatedBuildInputs = [
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
  disabledTests = [ "test_server_extension_list" "test_list_formats" "test_base_url" ];

  meta = with lib; {
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications.";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.elohmeier ];
  };
}
