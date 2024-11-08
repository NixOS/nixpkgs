{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # propagates
  django,
  jwcrypto,
  requests,
  oauthlib,

  # tests
  djangorestframework,
  pytest-cov-stub,
  pytest-django,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-oauth-toolkit";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-oauth-toolkit";
    rev = "refs/tags/${version}";
    hash = "sha256-Ya0KlX+vtLXN2Fgk0Gv7KemJCUTwkaH+4GQA1ByUlBY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    jwcrypto
    oauthlib
    requests
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  # xdist is disabled right now because it can cause race conditions on high core machines
  # https://github.com/jazzband/django-oauth-toolkit/issues/1300
  nativeCheckInputs = [
    djangorestframework
    pytest-cov-stub
    pytest-django
    # pytest-xdist
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Failed to get a valid response from authentication server. Status code: 404, Reason: Not Found.
    "test_response_when_auth_server_response_return_404"
  ];

  meta = {
    description = "OAuth2 goodies for the Djangonauts";
    homepage = "https://github.com/jazzband/django-oauth-toolkit";
    changelog = "https://github.com/jazzband/django-oauth-toolkit/django-filer/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mmai ];
  };
}
