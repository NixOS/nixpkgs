{
  lib,
  buildPythonPackage,
  celery,
  cron-descriptor,
  django-timezone-field,
  ephem,
  fetchFromGitHub,
  pytest-django,
  pytest-timeout,
  pytestCheckHook,
  python-crontab,
  pythonOlder,
  setuptools,
  tzdata,
}:

buildPythonPackage rec {
  pname = "django-celery-beat";
  version = "2.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "celery";
    repo = "django-celery-beat";
    tag = "v${version}";
    hash = "sha256-pakOpch5r2ug0UDSqEU34qr4Tz1/mkuFiHW+IOUuGcc=";
  };

  pythonRelaxDeps = [ "django" ];

  build-system = [ setuptools ];

  dependencies = [
    cron-descriptor
    python-crontab
    celery
    django-timezone-field
    tzdata
  ];

  nativeCheckInputs = [
    ephem
    pytest-timeout
    pytest-django
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Connection error
    "t/unit/test_schedulers.py"
  ];

  pythonImportsCheck = [ "django_celery_beat" ];

  meta = with lib; {
    description = "Celery Periodic Tasks backed by the Django ORM";
    homepage = "https://github.com/celery/django-celery-beat";
    changelog = "https://github.com/celery/django-celery-beat/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
