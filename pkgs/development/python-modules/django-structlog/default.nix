{
  asgiref,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  django,
  django-allauth,
  crispy-bootstrap5,
  django-environ,
  django-extensions,
  django-ipware,
  django-ninja,
  django-redis,
  djangorestframework,
  structlog,
  celery,
  factory-boy,
  pytest-asyncio,
  pytest-django,
  pytest-mock,
  redisTestHook,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-structlog";
  version = "10.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jrobichaud";
    repo = "django-structlog";
    tag = finalAttrs.version;
    hash = "sha256-BNZ+nk2NK5x2YsTDZjH5BVizXAyLZhKp8zRvkWi068k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    django
    structlog
    django-ipware
  ];

  optional-dependencies = {
    celery = [ celery ];
    commands = [ django-extensions ];
  };

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=config.settings.test_demo_app
  '';

  enabledTestPaths = [ "django_structlog_demo_project" ];

  pythonImportsCheck = [
    "django_structlog"
  ];

  nativeCheckInputs = [
    redisTestHook
    factory-boy
    pytest-asyncio
    pytest-django
    pytest-mock
    pytestCheckHook
    django-allauth
    crispy-bootstrap5
    django-environ
    django-ninja
    django-redis
    djangorestframework
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Structured Logging for Django";
    homepage = "https://github.com/jrobichaud/django-structlog";
    changelog = "https://github.com/jrobichaud/django-structlog/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
