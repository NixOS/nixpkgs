{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base, pep8 }:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1aaca95db795d6a9f7bba52ff83c7fd4139050d0df93ee3a5a448adcfa0c0ac";
  };

  nativeBuildInputs = [ pep8 ];

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = https://github.com/armills/jsonrpc-websocket;
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
