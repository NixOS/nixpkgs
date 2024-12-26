{
  lib,
  buildPythonPackage,
  django,
  django-redis,
  fetchFromGitHub,
  pymemcache,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-ratelimit";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jsocol";
    repo = "django-ratelimit";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZMtZSKOIIRSqH6eyC7bBeua7YLKyWW6NOXN/MDv9fy4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
    django-redis
    pymemcache
  ];

  pythonImportsCheck = [
    "django_ratelimit"
  ];

  checkPhase = ''
    runHook preCheck

    export DJANGO_SETTINGS_MODULE=test_settings
    python -m django test django_ratelimit

    runHook postCheck
  '';

  meta = with lib; {
    description = "Cache-based rate-limiting for Django";
    homepage = "https://github.com/jsocol/django-ratelimit";
    changelog = "https://github.com/jsocol/django-ratelimit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ derdennisop ];
  };
}
