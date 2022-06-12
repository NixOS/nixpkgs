{ lib
, stdenv
, buildPythonPackage
, fetchpatch
, fetchPypi
, pythonOlder
, pytestCheckHook
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
  version = "1.11.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1f32e0c1807ab2de37bf70af97a36b4436db0bc8af3124632b1f4441038bf95";
  };

  patches = [ (fetchpatch
    { name = "Normalize-file-name-and-path.patch";
      url = "https://github.com/jupyter-server/jupyter_server/pull/608/commits/345e26cdfd78651954b68708fa44119c2ac0dbd5.patch";
      sha256 = "1kqz3dyh2w0h1g1fbvqa13q17hb6y32694rlaasyg213mq6g4k32";
    })
  ];

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
