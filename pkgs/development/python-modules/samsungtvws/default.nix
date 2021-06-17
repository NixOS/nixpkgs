{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "1.6.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09nls4n0lbnr8nj8105lagr9h2my8lb1s2k285kmsbli36ywd8lj";
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
