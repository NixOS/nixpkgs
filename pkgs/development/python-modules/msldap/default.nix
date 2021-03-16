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
  version = "0.3.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tAMl1Xkb04Vfh18uS30eKX/IfeXhwER3J1lHXHxHlXY=";
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
