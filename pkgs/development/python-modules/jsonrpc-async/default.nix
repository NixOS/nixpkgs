{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adda3ff6e122b1932b6e20cf583666ea65db4248bc19b04811a4ccc0f0b03d95";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-async;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
