{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f1p3qv56jn4sdyp8gzf915nya6vr0rn2pbzld9x23y9jdjmibzw";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = http://github.com/armills/jsonrpc-async;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
