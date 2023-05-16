{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook

# propagates
, django
, jwcrypto
, requests
, oauthlib

# tests
, djangorestframework
, pytest-django
, pytest-xdist
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-oauth-toolkit";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-oGg5MD9p4PSUVkt5pGLwjAF4SHHf4Aqr+/3FsuFaybY=";
=======
    hash = "sha256-mynchdvrfBGKMeFFb2oDaANhtSCxq85Nibx7GfSY2nQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i '/cov/d' tox.ini
  '';

  propagatedBuildInputs = [
    django
    jwcrypto
    oauthlib
    requests
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    "django"
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

<<<<<<< HEAD
  # xdist is disabled right now because it can cause race conditions on high core machines
  # https://github.com/jazzband/django-oauth-toolkit/issues/1300
  nativeCheckInputs = [
    djangorestframework
    pytest-django
    # pytest-xdist
=======
  nativeCheckInputs = [
    djangorestframework
    pytest-django
    pytest-xdist
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Failed to get a valid response from authentication server. Status code: 404, Reason: Not Found.
    "test_response_when_auth_server_response_return_404"
  ];

  meta = with lib; {
    description = "OAuth2 goodies for the Djangonauts";
    homepage = "https://github.com/jazzband/django-oauth-toolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
  };
}
