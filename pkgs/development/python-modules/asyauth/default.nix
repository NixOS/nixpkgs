{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
, minikerberos
, pythonOlder
, unicrypto
}:

buildPythonPackage rec {
  pname = "asyauth";
  version = "0.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a4M2I+xIla+S3Hi5F+AZpZRicTp7EycGRWWldVyAV8E=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    minikerberos
    unicrypto
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "asyauth"
  ];

  meta = with lib; {
    description = "Unified authentication library";
    homepage = "https://github.com/skelsec/asyauth";
    changelog = "https://github.com/skelsec/asyauth/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
