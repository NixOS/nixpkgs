{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  jsonrpc-base,
  pytest-asyncio_0,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-websocket";
    tag = version;
    hash = "sha256-SgwEY/5MPEkSrcsQV4qkVgKmYYYsWA2YluReOz7sEjc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    jsonrpc-base
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
  ];

  pytestFlags = [
    "--asyncio-mode=auto"
  ];

  enabledTestPaths = [
    "tests.py"
  ];

  pythonImportsCheck = [ "jsonrpc_websocket" ];

  meta = {
    description = "JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-websocket";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
