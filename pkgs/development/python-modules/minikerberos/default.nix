{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchPypi,
  oscrypto,
  setuptools,
  six,
  tqdm,
  unicrypto,
}:

buildPythonPackage (finalAttrs: {
  pname = "minikerberos";
  version = "0.4.11";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-yy7LUPdiptCMPOTjoNIy5VLY75I0FwYbXifu1BtiGT0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    oscrypto
    six
    tqdm
    unicrypto
  ];

  # no tests are published: https://github.com/skelsec/minikerberos/pull/5
  doCheck = false;

  pythonImportsCheck = [ "minikerberos" ];

  meta = {
    description = "Kerberos manipulation library in Python";
    homepage = "https://github.com/skelsec/minikerberos";
    changelog = "https://github.com/skelsec/minikerberos/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
