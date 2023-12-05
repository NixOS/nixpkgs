{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, jsonrpc-async
, jsonrpc-websocket
}:

buildPythonPackage rec {
  pname = "pykodi";
  version = "0.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2fFkbZZ3RXMolaaGpkvvVfSYtNNB1bTsoRCin3GnVKM=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-async
    jsonrpc-websocket
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pykodi"
  ];

  meta = with lib; {
    description = "An async python interface for Kodi over JSON-RPC";
    homepage = "https://github.com/OnFreund/PyKodi";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ];
  };
}
