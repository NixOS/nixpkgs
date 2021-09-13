{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, jsonrpc-async
, jsonrpc-websocket
}:

buildPythonPackage rec {
  pname = "pykodi";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "483a764bd1dea9e8d133771fe31fb944b51030f86389e41a5e8b9bc1ff50fdde";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-async
    jsonrpc-websocket
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykodi" ];

  meta = with lib; {
    description = "An async python interface for Kodi over JSON-RPC";
    homepage = "https://github.com/OnFreund/PyKodi";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ];
  };
}
