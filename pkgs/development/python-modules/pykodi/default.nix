{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  jsonrpc-async,
  jsonrpc-websocket,
}:

buildPythonPackage rec {
  pname = "pykodi";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wNmVvl7lhDbRjBfXD0kmS45Q66bXKPCzZs4JhPQ78IE=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-async
    jsonrpc-websocket
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykodi" ];

  meta = {
    description = "Async python interface for Kodi over JSON-RPC";
    homepage = "https://github.com/OnFreund/PyKodi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
