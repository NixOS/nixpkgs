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
<<<<<<< HEAD
  version = "0.5.5";
=======
  version = "0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ewE3rECsydNFgfh53X/oB/VyXd54nSpVsxMRZPGuR3I=";
=======
    hash = "sha256-WMMqNSRDBwPQ/1ACgtuSvA50j+xNyjnxl7rTbx3uQ1w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
