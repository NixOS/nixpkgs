{ lib
, asn1crypto
, asysocks
, buildPythonPackage
, fetchPypi
, minikerberos
, pythonOlder
, unicrypto
}:

buildPythonPackage rec {
  pname = "asyauth";
<<<<<<< HEAD
  version = "0.0.14";
=======
  version = "0.0.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-EJLuSvkJrQBIrSM/dODhTtwPpnz67lmg4ZEwI4TPOVc=";
=======
    hash = "sha256-tVvqzKsCvvSgKB3xRBMnIQLEDzCaPO/h8cM8WMpzi6M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    asn1crypto
    asysocks
    minikerberos
    unicrypto
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "asyauth"
  ];

  meta = with lib; {
    description = "Unified authentication library";
    homepage = "https://github.com/skelsec/asyauth";
    changelog = "https://github.com/skelsec/asyauth/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
