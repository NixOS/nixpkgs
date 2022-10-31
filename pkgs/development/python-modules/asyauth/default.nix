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
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XUUeZ8yqnZEMj3fCtq8YrZJH6Ci77f2OKXcCIHMbY8w=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
