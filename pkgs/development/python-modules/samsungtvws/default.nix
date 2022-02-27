{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "2.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-F9Q5gEKS9aYz/FYj1x1EIP2rfjCcxfqqacYV16rJCgs=";
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
