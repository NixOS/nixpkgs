{ lib
, buildPythonPackage
, fetchFromGitHub
, authlib
, httpx
}:

buildPythonPackage rec {
  pname = "pypoint";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pypoint";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fO0un6YIK3jutzUxbu9mSqPZHfLa3pMtfxOy1iV3Qio=";
=======
    hash = "sha256-609Zme9IUl8eHNxzrYsRAg7bgZho/OklGM7oI+imyZQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    authlib
    httpx
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pypoint"
  ];

  meta = with lib; {
    description = "Python module for communicating with Minut Point";
    homepage = "https://github.com/fredrike/pypoint";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
