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
  version = "0.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zf1HqkqCpu0VtgMso7OaWCoTYQeDRXzh8Uda+AsVt0Q=";
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
