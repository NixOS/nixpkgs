{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  cryptography,
  dnspython,
  fetchPypi,
  minikerberos,
  oscrypto,
  setuptools,
  six,
  tqdm,
  unicrypto,
}:

buildPythonPackage (finalAttrs: {
  pname = "kerbad";
  version = "0.5.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-mD35zFBCpdZg9DENnhVc7SWvu6GjZf/NCQP8UMRwhQI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    cryptography
    dnspython
    minikerberos
    oscrypto
    six
    tqdm
    unicrypto
  ];

  # Tests require a live Kerberos server
  doCheck = false;

  pythonImportsCheck = [ "kerbad" ];

  meta = {
    description = "Kerberos manipulation library in pure Python";
    homepage = "https://github.com/CravateRouge/kerbad";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
