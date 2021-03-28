{ lib
, buildPythonPackage
, fetchPypi
, asn1crypto
, asysocks
, minikerberos
, prompt_toolkit
, tqdm
, winacl
, winsspi
}:

buildPythonPackage rec {
  pname = "msldap";
  version = "0.3.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0sMi5PpwMWf/W+Hu0akQVF/1ZkbanfOzYDC3R6lZrSE=";
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    minikerberos
    prompt_toolkit
    tqdm
    winacl
    winsspi
  ];

  # Project doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "msldap" ];

  meta = with lib; {
    description = "Python LDAP library for auditing MS AD";
    homepage = "https://github.com/skelsec/msldap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
