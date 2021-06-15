{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, jsonrpc-base
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fmw8xjzlhi7r84swn4w3njy389qqll5ad5ljdq5n2wpg424k98h";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-base
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlagsArray = [ "tests.py" ];

  meta = with lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-websocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
