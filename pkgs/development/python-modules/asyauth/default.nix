{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchPypi,
  minikerberos,
  setuptools,
  unicrypto,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyauth";
  version = "0.0.25";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-YyZZnnlRvfn9Hf7iCBHbvvQfX91ZHbzLjYr21O3DZ3U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    minikerberos
    unicrypto
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "asyauth" ];

  meta = {
    description = "Unified authentication library";
    homepage = "https://github.com/skelsec/asyauth";
    changelog = "https://github.com/skelsec/asyauth/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
