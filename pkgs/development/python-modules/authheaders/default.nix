{ lib
, authres
, buildPythonPackage
, dkimpy
, dnspython
, fetchFromGitHub
, publicsuffix2
, pythonOlder
, pytestCheckHook
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.15.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValiMail";
    repo = "authentication-headers";
    rev = "refs/tags/${version}";
    hash = "sha256-vtLt7JUdLF0gBWgMzP65UAR6A9BnTech5n0alFErcSQ=";
  };

  propagatedBuildInputs = [
    authres
    dnspython
    dkimpy
    publicsuffix2
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "authheaders"
  ];

  meta = with lib; {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
