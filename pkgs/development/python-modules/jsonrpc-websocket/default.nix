{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base, pep8 }:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029gxp6f06gmba7glxfdz5xfhs5kkqph7x78k38qqvdrmca4z450";
  };

  nativeBuildInputs = [ pep8 ];

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  meta = with stdenv.lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/armills/jsonrpc-websocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
