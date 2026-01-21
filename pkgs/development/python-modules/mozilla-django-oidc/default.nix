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
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "mozilla-django-oidc";
    tag = version;
    hash = "sha256-5J2lzGGdjoXzdzfKdmfUaSM7KQ6Hn7KerBtoKzFsZfY=";
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
    changelog = "https://github.com/mozilla/mozilla-django-oidc/releases/tag/${src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
