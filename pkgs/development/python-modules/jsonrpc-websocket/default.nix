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
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-websocket";
    rev = version;
    sha256 = "aAXY1OUsF83rGQ1sg1lDrbWmxWqJJ+ZnuvHR1Y+ZDs4=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-base
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlagsArray = [
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
