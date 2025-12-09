{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  jsonrpc-base,
  pytest-asyncio_0,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "3.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-websocket";
    tag = version;
    hash = "sha256-m2HiS03PZ6oiHJJ9Z2+5CfiHKIWJ1yzDqlZj22/JNAE=";
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

  meta = with lib; {
    description = "JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-websocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
