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
  django-ninja,
  djangorestframework,
  pytest-cov-stub,
  pytest-django,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-oauth-toolkit";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-oauth-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-UsnfGOyVk5w0grG6cTgMmfo+HyrZtsER338YobLyk08=";
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
    # See below about xdist
    substituteInPlace pyproject.toml \
      --replace-fail '    "-n", "auto",' "" \
      --replace-fail '    "--dist", "loadfile",' ""
  '';

  # xdist is disabled right now because it can cause race conditions on high core machines
  # https://github.com/jazzband/django-oauth-toolkit/issues/1300
  nativeCheckInputs = [
    djangorestframework
    pytest-cov-stub
    pytest-django
    django-ninja
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
    changelog = "https://github.com/jazzband/django-oauth-toolkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
