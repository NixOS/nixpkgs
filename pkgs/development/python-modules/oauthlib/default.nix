{ lib
, blinker
, buildPythonPackage
, cryptography
, fetchFromGitHub
, mock
, pyjwt
, pytestCheckHook
, pythonOlder

# for passthru.tests
, django-allauth
, django-oauth-toolkit
, google-auth-oauthlib
, requests-oauthlib
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

  passthru.tests = {
    inherit
      django-allauth
      django-oauth-toolkit
      google-auth-oauthlib
      requests-oauthlib;
  };

  meta = with lib; {
    description = "Generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    homepage = "https://github.com/idan/oauthlib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prikhi ];
  };
}
