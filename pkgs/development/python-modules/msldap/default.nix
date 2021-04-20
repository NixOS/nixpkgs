{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.3.29";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = pname;
    rev = version;
    sha256 = "sha256-blC65xSGe2dD/g+u9+eYRwaNCv5icdUxApP3BUVOHKo=";
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
