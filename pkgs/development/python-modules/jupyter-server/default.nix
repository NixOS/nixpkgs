{ lib
, stdenv
, buildPythonPackage
, fetchpatch
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
, ipython_genutils
, traitlets
, jupyter-core
, jupyter-client
, jupyter-events
, jupyter-server-terminals
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
  pname = "jupyter-server";
  version = "2.0.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jupyter_server";
    inherit version;
    hash= "sha256-jddZkukLfKVWeUoe1cylEmPGl6vG0N9WGvV0qhwKAz8=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-39968.patch";
      url = "https://github.com/jupyter-server/jupyter_server/commit/290362593b2ffb23c59f8114d76f77875de4b925.patch";
      hash = "sha256-EhWKTpjPp2iwLWpR4O6oZpf3yJmwe25SEG288wAiOJE=";
    })
    (fetchpatch {
      name = "CVE-2023-40170.patch";
      url = "https://github.com/jupyter-server/jupyter_server/commit/87a4927272819f0b1cae1afa4c8c86ee2da002fd.patch";
      hash = "sha256-D+Dk2dQKNrpXMer0Ezo7PlBwRzHmEi7bGZ45+uNChF8=";
    })
  ];

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
  ];

  propagatedBuildInputs = [
    argon2-cffi
    jinja2
    tornado
    pyzmq
    ipython_genutils
    traitlets
    jupyter-core
    jupyter-client
    jupyter-events
    jupyter-server-terminals
    nbformat
    nbconvert
    send2trash
    terminado
    prometheus-client
    anyio
    websocket-client
    requests-unixsocket
  ];

  nativeCheckInputs = [
    ipykernel
    pandoc
    pytestCheckHook
    pytest-console-scripts
    pytest-jupyter
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
    # nbconvert failed: `relax_add_props` kwargs of validate has been
    # deprecated for security reasons, and will be removed soon.
    "tests/nbconvert/test_handlers.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.elohmeier ];
  };
}
