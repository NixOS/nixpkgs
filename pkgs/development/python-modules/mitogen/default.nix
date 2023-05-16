{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mitogen";
<<<<<<< HEAD
  version = "0.3.4";
=======
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tMpjmSqZffFGbo06W/FAut584F8eOPrcLKjj2bnB+Zo=";
=======
    hash = "sha256-cx0q2Y9A6UzpdD1kuGBtXIs9oBGFpkIyvPfN2hj+A1g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [
    "mitogen"
  ];

  meta = with lib; {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
