{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "383f331e28cd8f6e3fa86f3e7052efa541b7ae8bf328a4e692aa045cfc0ecf25";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-async;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
