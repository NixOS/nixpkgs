{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "circuit-webhook";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NhePKBfzdkw7iVHmVrOxf8ZcQrb1Sq2xMIfu4P9+Ppw=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "circuit_webhook" ];

  meta = {
    description = "Module for Unify Circuit API webhooks";
    homepage = "https://github.com/braam/unify/tree/master/circuit-webhook-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
