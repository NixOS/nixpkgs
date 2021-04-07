{ lib, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base, pep8
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10a5490479970b5b7093b4345528c538a1e1a51d9c58ae09ca2742fa6547bc3a";
  };

  nativeBuildInputs = [ pep8 ];

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  checkInputs = [ pytestCheckHook pytest-asyncio ];
  pytestFlagsArray = [ "tests.py" ];

  meta = with lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/armills/jsonrpc-websocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
