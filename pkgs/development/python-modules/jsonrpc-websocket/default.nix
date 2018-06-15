{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf349bee4ab96db2e457b6a71a45380e1a9cf3e1ceb08260ecfd9928040ebe71";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-websocket;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
