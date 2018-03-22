{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cijqb8fvv9iq5ds9y5sj0gd6lapi90mgqvpkczp28fxz440ihq4";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-websocket;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
