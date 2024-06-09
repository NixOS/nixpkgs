{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "circuit-webhook";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NhePKBfzdkw7iVHmVrOxf8ZcQrb1Sq2xMIfu4P9+Ppw=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "circuit_webhook" ];

  meta = with lib; {
    description = "Module for Unify Circuit API webhooks";
    homepage = "https://github.com/braam/unify/tree/master/circuit-webhook-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
