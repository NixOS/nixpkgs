{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6241a221b52e18265fe6bb59c60633acebb6fb5ef8c04de9a076b757aa133b86";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-async;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
