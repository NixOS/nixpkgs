{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  djangorestframework,
  django,
  josepy,
  requests,
  cryptography,
}:

buildPythonPackage rec {
  pname = "mozilla-django-oidc";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "mozilla-django-oidc";
    rev = version;
    hash = "sha256-72F1aLLIId+YClTrpOz3bL8LSq6ZhZjjtv8V/GJGkqs=";
  };

  # Fix test with latest cryptography
  # Upstream PR: https://github.com/mozilla/mozilla-django-oidc/pull/556
  patches = [
    ./cryptography.patch
  ];

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    djangorestframework
  ];

  checkPhase = ''
    runHook preCheck

    PYTHONPATH=.:$PYTHONPATH DJANGO_SETTINGS_MODULE=tests.settings django-admin test

    runHook postCheck
  '';

  dependencies = [
    django
    josepy
    requests
    cryptography
  ];

  meta = {
    description = "Django OpenID Connect library";
    homepage = "https://github.com/mozilla/mozilla-django-oidc";
    changelog = "https://github.com/mozilla/mozilla-django-oidc/releases/tag/${src.rev}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
