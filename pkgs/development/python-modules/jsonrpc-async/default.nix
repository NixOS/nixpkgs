{ lib, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base }:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52b1cfe584df8bc2d19930fc18c5e982378690c825ba6916103724195ba52099";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with lib; {
    description = "A JSON-RPC client library for asyncio";
    homepage = "https://github.com/armills/jsonrpc-async";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
