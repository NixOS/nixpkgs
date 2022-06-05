{ lib
, buildPythonPackage
, fetchPypi
, asn1crypto
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
  version = "0.3.38";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zJEp8/jPTAb3RpzyXySdtVl2uSLpSirGkJh7GB/3Qwc=";
  };

  propagatedBuildInputs = [
    asn1crypto
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
