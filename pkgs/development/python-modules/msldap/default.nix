{ lib
, buildPythonPackage
, fetchPypi
, asn1crypto
, asyauth
, asysocks
, minikerberos
, prompt-toolkit
, tqdm
, winacl
, winsspi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "msldap";
  version = "0.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NCcEUSDsvMUCV07Gzh18NaKSw4On0XPT3UytBeeT3qo=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asyauth
    asysocks
    minikerberos
    prompt-toolkit
    tqdm
    winacl
    winsspi
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "msldap"
  ];

  meta = with lib; {
    description = "Python LDAP library for auditing MS AD";
    homepage = "https://github.com/skelsec/msldap";
    changelog = "https://github.com/skelsec/msldap/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
