{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # propagates
  django,
  jwcrypto,
  oauthlib,
  requests,

  # tests
  django-ninja,
  djangorestframework,
  pytest-cov-stub,
  pytest-django_4_12,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-oauth-toolkit";
  version = "2.3.0"; # pinned for pretix, don't update to 2.4.0
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-oauth-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-oGg5MD9p4PSUVkt5pGLwjAF4SHHf4Aqr+/3FsuFaybY=";
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

  nativeCheckInputs = [
    djangorestframework
    pytest-cov-stub
    pytest-django_4_12
    pytest-xdist
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Failed to get a valid response from authentication server. Status code: 404, Reason: Not Found.
    "test_response_when_auth_server_response_return_404"
    # AssertionError: 'does not exist' not found in "Please correct the following errors:\n - user: ['user instance with id 783 is not a valid choice.']\n"
    "test_validation_failed_message"
  ];

  meta = {
    description = "OAuth2 goodies for the Djangonauts";
    homepage = "https://github.com/jazzband/django-oauth-toolkit";
    changelog = "https://github.com/jazzband/django-oauth-toolkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
