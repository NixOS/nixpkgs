{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
, oscrypto
, pythonOlder
, unicrypto
}:

buildPythonPackage rec {
  pname = "minikerberos";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wFz82EaxlzsrDVAenp+iomNUPXdisFL8gD/B3oSShqM=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    oscrypto
    unicrypto
  ];

  # no tests are published: https://github.com/skelsec/minikerberos/pull/5
  doCheck = false;

  pythonImportsCheck = [
    "minikerberos"
  ];

  meta = with lib; {
    description = "Kerberos manipulation library in Python";
    homepage = "https://github.com/skelsec/minikerberos";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
