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

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.4.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CVqYChl2rf9Iw94fc9de/ps52nIU3HyJGiNjJAcWqec=";
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
    changelog = "https://github.com/skelsec/minikerberos/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
