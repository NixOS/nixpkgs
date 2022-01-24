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
}:

buildPythonPackage rec {
  pname = "msldap";
  version = "0.3.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fX+W1Bq4F0/6DyxWeA6zvoswFQCdDpSk29g7nq1cYYE=";
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
  pythonImportsCheck = [ "msldap" ];

  meta = with lib; {
    description = "Python LDAP library for auditing MS AD";
    homepage = "https://github.com/skelsec/msldap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
