{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchPypi,
  minikerberos,
  pythonOlder,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "asyauth";
  version = "0.0.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QQVgIPdonPXwpVl1nH8Cps4nGb2oTfeDvRBY1XgeUUs=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    minikerberos
    unicrypto
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "asyauth" ];

  meta = with lib; {
    description = "Unified authentication library";
    homepage = "https://github.com/skelsec/asyauth";
    changelog = "https://github.com/skelsec/asyauth/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
