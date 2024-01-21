{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, jsonrpc-base
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "3.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-websocket";
    rev = version;
    hash = "sha256-CdYa4gcbG3EM1glxLU1hyqbNse87KJKjwSRQSFfDMM0=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-base
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
    "tests.py"
  ];

  pythonImportsCheck = [
    "jsonrpc_websocket"
  ];

  meta = with lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-websocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
