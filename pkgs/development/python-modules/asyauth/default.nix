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
  version = "0.0.24";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/Z+BrLpBSBxl0wXFfZ4Xv8ydbUWZ1uWV2RImRUtvGx0=";
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
