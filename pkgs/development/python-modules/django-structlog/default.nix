{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  python,
  pkgs,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-structlog";
  version = "9.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jrobichaud";
    repo = "django-structlog";
    tag = version;
    hash = "sha256-SEigOdlXZtfLAgRgGkv/eDNDAiiHd7YthRJ/H6e1v5U=";
  };

  disabled = pythonOlder "3.9";

  dependencies = with python.pkgs; [
    colorama
    django
    django-allauth
    django-crispy-bootstrap5
    django-crispy-forms
    django-environ
    django-extensions
    django-ipware
    django-model-utils
    django-ninja
    django-redis
    djangorestframework
    structlog
  ];

  optional-dependencies.celery = with python.pkgs; [ celery ];

  build-system = [ setuptools ];
  doCheck = true;
  preCheck = ''
    export DJANGO_SETTINGS_MODULE=config.settings.test_demo_app

    ${pkgs.valkey}/bin/redis-server &
    REDIS_PID=$!
  '';
  postCheck = ''
    kill $REDIS_PID
  '';

  pytestFlags = [
    "-x"
    "--cov=./django_structlog_demo_project"
    "--cov-append django_structlog_demo_project"
  ];
  pythonImportsCheck = [
    "structlog"
    "django_structlog"
  ];

  nativeCheckInputs = with python.pkgs; [
    celery
    factory-boy
    pytest-asyncio
    pytest-cov
    pytest-django
    pytest-mock
    pytest-sugar
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Structured Logging for Django";
    homepage = "https://github.com/jrobichaud/django-structlog";
    changelog = "https://github.com/jrobichaud/django-structlog/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
