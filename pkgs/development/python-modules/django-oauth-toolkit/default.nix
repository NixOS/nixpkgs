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
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-mynchdvrfBGKMeFFb2oDaANhtSCxq85Nibx7GfSY2nQ=";
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

  checkInputs = [
    djangorestframework
    pytest-django
    pytest-xdist
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
