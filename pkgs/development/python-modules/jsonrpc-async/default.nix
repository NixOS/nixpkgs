{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "488ab3b63a96c246f7ded14b3458eb13a36e3e16eb4319aa56806476517c7433";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-async;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
