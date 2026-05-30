{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  pycrdt,
  pycrdt-store,
  sqlite-anyio,

  # optional-dependencies
  channels,

  # tests
  httpx-ws,
  hypercorn,
  pytest-asyncio,
  pytestCheckHook,
  trio,
  uvicorn,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycrdt-websocket";
  version = "0.16.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt-websocket";
    tag = finalAttrs.version;
    hash = "sha256-OZ3LaXFwZY0gcLVHSkNKRrFZuCbggD9EeQNXYIVOSZ0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    pycrdt
    pycrdt-store
    sqlite-anyio
  ];

  optional-dependencies = {
    django = [ channels ];
  };

  pythonImportsCheck = [ "pycrdt.websocket" ];

  nativeCheckInputs = [
    httpx-ws
    hypercorn
    pytest-asyncio
    pytestCheckHook
    trio
    uvicorn
    websockets
  ];

  disabledTests = [
    # Looking for a certfile
    # FileNotFoundError: [Errno 2] No such file or directory
    "test_asgi"
    "test_yroom_restart"
  ];

  disabledTestPaths = [
    # requires nodejs and installed js modules
    "tests/test_pycrdt_yjs.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "WebSocket Connector for pycrdt";
    homepage = "https://github.com/jupyter-server/pycrdt-websocket";
    changelog = "https://github.com/jupyter-server/pycrdt-websocket/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.jupyter ];
  };
})
