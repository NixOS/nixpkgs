{
  lib,
  buildPythonPackage,
  case,
  celery,
  cron-descriptor,
  django-timezone-field,
  ephem,
  fetchPypi,
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
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-91stEpcx8SFL6Dg+GPrmv+rNtV3/shFs6EkiLAEG+a0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    case
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
    changelog = "https://github.com/celery/django-celery-beat/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
