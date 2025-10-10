{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiosqlite,
  anyio,
  y-py,

  # testing
  pytest-asyncio,
  pytestCheckHook,
  uvicorn,
  websockets,
}:

buildPythonPackage rec {
  pname = "ypy-websocket";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "ypy-websocket";
    tag = "v${version}";
    hash = "sha256-48x+MUhev9dErC003XOP3oGKd5uOghlBFgcR8Nm/0xs=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "aiofiles" ];

  dependencies = [
    aiosqlite
    anyio
    y-py
  ];

  pythonImportsCheck = [ "ypy_websocket" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    uvicorn
    websockets
  ];

  disabledTestPaths = [
    # requires installing yjs Node.js module
    "tests/test_ypy_yjs.py"
    # Depends on no longer maintained ypy
    "tests/test_asgi.py"
  ];

  meta = {
    changelog = "https://github.com/y-crdt/ypy-websocket/blob/${src.rev}/CHANGELOG.md";
    description = "WebSocket Connector for Ypy";
    homepage = "https://github.com/y-crdt/ypy-websocket";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
