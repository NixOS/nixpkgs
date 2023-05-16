{ lib
, asyauth
, asysocks
, buildPythonPackage
, colorama
, fetchPypi
, minikerberos
, prompt-toolkit
, pycryptodomex
, pythonOlder
, six
, tqdm
, winacl
, winsspi
}:

buildPythonPackage rec {
  pname = "aiosmb";
<<<<<<< HEAD
  version = "0.4.6";
=======
  version = "0.4.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Y0Z76YP1cWcfMKZOn2L6z4B+hAdibxJOYBzT3WV6FcY=";
=======
    hash = "sha256-IGIEmM9eZ5T+op3ctGr72oy/cU48+OHaFJaZ8DRTY38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    asyauth
    asysocks
    colorama
    minikerberos
    prompt-toolkit
    pycryptodomex
    six
    tqdm
    winacl
    winsspi
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "aiosmb"
  ];

  meta = with lib; {
    description = "Python SMB library";
    homepage = "https://github.com/skelsec/aiosmb";
    changelog = "https://github.com/skelsec/aiosmb/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
