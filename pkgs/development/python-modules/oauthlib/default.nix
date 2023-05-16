{ lib
, blinker
, buildPythonPackage
, cryptography
, fetchFromGitHub
, mock
, pyjwt
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD

# for passthru.tests
, django-allauth
, django-oauth-toolkit
, google-auth-oauthlib
, requests-oauthlib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "oauthlib";
  version = "3.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KADS1pEaLYi86LEt2VVuz8FVTBANzxC8EeQLgGMxuBU=";
  };

  propagatedBuildInputs = [
    blinker
    cryptography
    pyjwt
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "oauthlib"
  ];

<<<<<<< HEAD
  passthru.tests = {
    inherit
      django-allauth
      django-oauth-toolkit
      google-auth-oauthlib
      requests-oauthlib;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    homepage = "https://github.com/idan/oauthlib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prikhi ];
  };
}
