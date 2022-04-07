{ lib, buildPythonPackage, fetchPypi, isPy27
, aiohttp
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "2.5.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AFCN1b80GZ24g3oWe1qqc72yWQy4+/sorL8zwOYM7vo=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
    websocket-client
    websockets
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "samsungtvws" ];

  meta = with lib; {
    description = "Samsung Smart TV WS API wrapper";
    homepage = "https://github.com/xchwarze/samsung-tv-ws-api";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
