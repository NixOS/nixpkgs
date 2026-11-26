{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  jwcrypto,
  oauthlib,
  requests,
  urllib3,

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
  version = "3.4.1-unstable-2026-10-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-oauth";
    repo = "django-oauth-toolkit";
    rev = "285ba9c38306bccf798cc4f9fe64fbbae8659e40";
    hash = "sha256-wz8W9VSl+vEh+/dV2BFCMtSJGvrpsJSStSwI0ETfLoI=";
  };

  patches = [
    # https://github.com/django-oauth/django-oauth-toolkit/pull/1951
    ./oauthlib-4.0.1-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    django
    jwcrypto
    oauthlib
    requests
    urllib3
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
    # See below about xdist
    substituteInPlace pyproject.toml \
      --replace-fail '    "--dist", "loadfile",' ""
  '';

  nativeCheckInputs = [
    django-ninja
    djangorestframework
    pytest-cov-stub
    pytest-django_4_12
    django-ninja
    # pytest-xdist
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Failed to get a valid response from authentication server. Status code: 404, Reason: Not Found.
    "test_response_when_auth_server_response_return_404"
  ];

  meta = {
    description = "OAuth2 goodies for the Djangonauts";
    homepage = "https://github.com/django-oauth/django-oauth-toolkit";
    # TODO: restore when switching back to a release
    #changelog = "https://github.com/django-oauth/django-oauth-toolkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
