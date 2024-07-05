{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  anyio,
  channels,
  httpx-ws,
  hypercorn,
  pycrdt,
  pytest-asyncio,
  pytestCheckHook,
  sqlite-anyio,
  trio,
  uvicorn,
  websockets,
}:

buildPythonPackage rec {
  pname = "pycrdt-websocket";
  version = "0.13.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt-websocket";
    rev = "refs/tags/v${version}";
    hash = "sha256-dzlmgxrdQ97+DO/vDtoX7PIOpngEE+FGUGq1vdVmhNw=";
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

  disabledTestPaths = [
    # requires nodejs and installed js modules
    "tests/test_pycrdt_yjs.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "WebSocket Connector for pycrdt";
    homepage = "https://github.com/jupyter-server/pycrdt-websocket";
    changelog = "https://github.com/jupyter-server/pycrdt-websocket/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = teams.jupyter.members;
  };
}
