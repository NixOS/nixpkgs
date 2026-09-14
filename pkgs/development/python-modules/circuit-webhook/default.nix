{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "circuit-webhook";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NhePKBfzdkw7iVHmVrOxf8ZcQrb1Sq2xMIfu4P9+Ppw=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "circuit_webhook" ];

  meta = {
    description = "Module for Unify Circuit API webhooks";
    homepage = "https://github.com/braam/unify/tree/master/circuit-webhook-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
