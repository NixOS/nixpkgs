{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetgear";
<<<<<<< HEAD
  version = "0.10.10";
=======
  version = "0.10.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatMaul";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-5Lj2cK/SOGgaPu8dI9X3Leg4dPAY7tdIHCzFnNaube8=";
=======
    hash = "sha256-VYiXFdUD4q6d7KraA26SFV29k53AoluCj7ACMgNQcLU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "pynetgear"
  ];

  # Tests don't pass
  # https://github.com/MatMaul/pynetgear/issues/109
  doCheck = false;

  meta = with lib; {
    description = "Module for interacting with Netgear wireless routers";
    homepage = "https://github.com/MatMaul/pynetgear";
    changelog = "https://github.com/MatMaul/pynetgear/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
