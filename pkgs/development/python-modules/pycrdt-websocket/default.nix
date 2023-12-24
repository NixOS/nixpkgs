{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
, aiosqlite
, anyio
, channels
, pycrdt
, pytest-asyncio
, pytestCheckHook
, uvicorn
, websockets
}:

buildPythonPackage rec {
  pname = "pycrdt-websocket";
  version = "0.12.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt-websocket";
    rev = "refs/tags/v${version}";
    hash = "sha256-dTjWujRMYpg8XZ0OkEG49OLIAPj8qnZl+W7713NKVaA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiosqlite
    anyio
    pycrdt
  ];

  passthru.optional-dependencies = {
    django = [
      channels
    ];
  };

  pythonImportsCheck = [
    "pycrdt_websocket"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
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
