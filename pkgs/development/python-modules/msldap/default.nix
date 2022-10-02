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
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+zfFCWtqIrK0tQNJ+noilvvXO6y1umWoNQ2TvhDosls=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
