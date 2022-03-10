{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "2.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2ly9lbnIHGHB55ml10jKE7dC5LdN1ToGW4GqfxTC5kI=";
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
