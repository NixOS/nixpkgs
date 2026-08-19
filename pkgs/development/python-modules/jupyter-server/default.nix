{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-jupyter-builder,
  hatchling,

  # dependencies
  anyio,
  argon2-cffi,
  jinja2,
  jupyter-client,
  jupyter-core,
  jupyter-events,
  jupyter-server-terminals,
  nbconvert,
  nbformat,
  overrides,
  packaging,
  prometheus-client,
  pyzmq,
  send2trash,
  terminado,
  tornado,
  traitlets,
  websocket-client,

  # tests
  addBinToPathHook,
  flaky,
  ipykernel,
  pytest-console-scripts,
  pytest-jupyter,
  pytest-timeout,
  pytestCheckHook,
  requests,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-server";
  version = "2.20.0";
  pyproject = true;
  __structuredAttrs = true;

  # Using the pypi archive to avoid building the node artifacts from source
  src = fetchPypi {
    pname = "jupyter_server";
    inherit (finalAttrs) version;
    hash = "sha256-tXeLozfYAVo9wrgIA+zdWsGNN5f932GlDqX7RytOvhQ=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies = [
    anyio
    argon2-cffi
    jinja2
    jupyter-client
    jupyter-core
    jupyter-events
    jupyter-server-terminals
    nbconvert
    nbformat
    overrides
    packaging
    prometheus-client
    pyzmq
    send2trash
    terminado
    tornado
    traitlets
    websocket-client
  ];

  # https://github.com/NixOS/nixpkgs/issues/299427
  stripExclude = lib.optionals stdenv.hostPlatform.isDarwin [ "favicon.ico" ];

  pythonImportsCheck = [ "jupyter_server" ];

  nativeCheckInputs = [
    addBinToPathHook
    flaky
    ipykernel
    pytest-console-scripts
    pytest-jupyter
    pytest-timeout
    pytestCheckHook
    requests
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # AssertionError
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    "test_cull_idle"
    "test_server_extension_list"
    "test_subscribe_websocket"
    # test is presumable broken in sandbox
    "test_authorized_requests"
    # Fails under load on Hydra; kernel stays in 'starting' state due to a zmq socket error
    "test_cull_connected"
    "test_execution_state"
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
    description = "Backend—i.e. core services, APIs, and REST endpoints—to Jupyter web applications";
    homepage = "https://github.com/jupyter-server/jupyter_server";
    changelog = "https://github.com/jupyter-server/jupyter_server/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsdOriginal;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-server";
  };
})
