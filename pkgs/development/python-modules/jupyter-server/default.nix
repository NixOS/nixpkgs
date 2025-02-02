{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  pytestCheckHook,
  pytest-console-scripts,
  pytest-jupyter,
  pytest-timeout,
  argon2-cffi,
  jinja2,
  tornado,
  pyzmq,
  ipykernel,
  traitlets,
  jupyter-core,
  jupyter-client,
  jupyter-events,
  jupyter-server-terminals,
  nbformat,
  nbconvert,
  packaging,
  send2trash,
  terminado,
  prometheus-client,
  anyio,
  websocket-client,
  overrides,
  requests,
  flaky,
}:

buildPythonPackage rec {
  pname = "jupyter-server";
  version = "2.14.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_server";
    inherit version;
    hash = "sha256-ZglQIaqWOM7SdsJIsdgYYuTFDyktV1kgu+lg3hxWsSs=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies = [
    argon2-cffi
    jinja2
    tornado
    pyzmq
    traitlets
    jupyter-core
    jupyter-client
    jupyter-events
    jupyter-server-terminals
    nbformat
    nbconvert
    packaging
    send2trash
    terminado
    prometheus-client
    anyio
    websocket-client
    overrides
  ];

  # https://github.com/NixOS/nixpkgs/issues/299427
  stripExclude = lib.optionals stdenv.hostPlatform.isDarwin [ "favicon.ico" ];

  nativeCheckInputs = [
    ipykernel
    pytestCheckHook
    pytest-console-scripts
    pytest-jupyter
    pytest-timeout
    requests
    flaky
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
    # 19 failures on python 3.13:
    # ResourceWarning: unclosed database in <sqlite3.Connection object at 0x7ffff2a0cc70>
    # TODO: Can probably be removed at the next update
    "-W"
    "ignore::pytest.PytestUnraisableExceptionWarning"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
  '';

  disabledTests =
    [
      "test_cull_idle"
      "test_server_extension_list"
      "test_subscribe_websocket"
      # test is presumable broken in sandbox
      "test_authorized_requests"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # attempts to use trashcan, build env doesn't allow this
      "test_delete"
      # Insufficient access privileges for operation
      "test_regression_is_hidden"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Failed: DID NOT RAISE <class 'tornado.web.HTTPError'>
      "test_copy_big_dir"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # TypeError: the JSON object must be str, bytes or bytearray, not NoneType
      "test_terminal_create_with_cwd"
    ];

  disabledTestPaths = [
    "tests/services/kernels/test_api.py"
    "tests/services/sessions/test_api.py"
    # nbconvert failed: `relax_add_props` kwargs of validate has been
    # deprecated for security reasons, and will be removed soon.
    "tests/nbconvert/test_handlers.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_server/blob/v${version}/CHANGELOG.md";
    description = "Backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    mainProgram = "jupyter-server";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    license = lib.licenses.bsdOriginal;
    maintainers = lib.teams.jupyter.members;
  };
}
