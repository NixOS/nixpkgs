{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, websocket_client
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "1.5.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "054rr8hiacdjfxqssnxnd3xp9hh8350zjzzjvh1199bpps4l1l6n";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace "websocket-client==" "websocket-client>="
  '';

  requiredPythonModules = [
    websocket_client
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
