{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e74e490fefa3b8f33620fca98f7cd9a53fb765b9ed6f78360482a3f364230885";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-websocket;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
