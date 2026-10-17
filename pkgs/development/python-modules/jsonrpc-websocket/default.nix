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

buildPythonPackage (finalAttrs: {
  pname = "jsonrpc-websocket";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-websocket";
    tag = finalAttrs.version;
    hash = "sha256-vhE5jee3ryrKFm9s8SFklBIk+pV8FkUERwWQ75u/PIw=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/emlove/jsonrpc-websocket/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})
