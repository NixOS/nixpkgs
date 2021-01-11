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
  version = "0.3.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ivq56953skql8f255nqx2sg4mm0kz2pr5b4dx62dx7jdgd1xym3";
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
