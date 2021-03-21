{ lib, buildPythonPackage, fetchPypi, aiohttp, jsonrpc-async, jsonrpc-websocket }:

buildPythonPackage rec {
  pname = "pykodi";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "099xyn5aql5mdim6kh4hwx0fg1a3bx73qdvwr48nz23cljmmk1m8";
  };

  propagatedBuildInputs = [ aiohttp jsonrpc-async jsonrpc-websocket ];

  pythonImportsCheck = [ "pykodi" ];

  meta = with lib; {
    description = "An async python interface for Kodi over JSON-RPC";
    homepage = "https://github.com/OnFreund/PyKodi";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ];
  };
}
