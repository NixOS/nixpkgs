{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40949836996c0a8104e7878997d3f68bda4561e9d3af64e5cd178127ec3c2778";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-websocket;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
