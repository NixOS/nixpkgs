{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  jsonrpc-base,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "3.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-websocket";
    rev = "refs/tags/${version}";
    hash = "sha256-CdYa4gcbG3EM1glxLU1hyqbNse87KJKjwSRQSFfDMM0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    jsonrpc-base
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
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
