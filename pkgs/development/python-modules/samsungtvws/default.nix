{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "1.7.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "431af8348164cbb56b62492c3fde7ab81911b7905c8009580ccc54bd3f50f7ee";
  };

  propagatedBuildInputs = [
    websocket-client
    requests
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
