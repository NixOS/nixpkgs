{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  pycrdt,
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

buildPythonPackage rec {
  pname = "pycrdt-websocket";
  version = "0.15.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt-websocket";
    tag = "v${version}";
    hash = "sha256-piNd85X5YsTAOC9frYQRDyb/DPfzZicIPJ+bEVzgOsU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    pycrdt
    sqlite-anyio
  ];

  optional-dependencies = {
    django = [ channels ];
  };

  pythonImportsCheck = [ "pycrdt_websocket" ];

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
    changelog = "https://github.com/jupyter-server/pycrdt-websocket/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.jupyter ];
  };
}
