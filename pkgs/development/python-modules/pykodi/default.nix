{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, jsonrpc-async
, jsonrpc-websocket
}:

buildPythonPackage rec {
  pname = "pykodi";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1al2q4jiqxjnz0j2xvs2hqzrz6fm3hmda5zjnkp8gdvgchd1cmn7";
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
