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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eeaaac2330f6f1cdafd378ddf5287a47a7c8609ab212a2f576121c1e61c7a344";
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
