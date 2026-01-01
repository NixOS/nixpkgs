{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  celery,
  cron-descriptor,
  django-timezone-field,
  python-crontab,
  tzdata,

  # tests
  ephem,
  pytest-django,
  pytest-timeout,
  pytestCheckHook,
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "django-celery-beat";
  version = "2.8.1";
  pyproject = true;

<<<<<<< HEAD
=======
  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "celery";
    repo = "django-celery-beat";
    tag = "v${version}";
    hash = "sha256-pakOpch5r2ug0UDSqEU34qr4Tz1/mkuFiHW+IOUuGcc=";
  };

  pythonRelaxDeps = [ "django" ];

  build-system = [ setuptools ];

  dependencies = [
<<<<<<< HEAD
    celery
    cron-descriptor
    django-timezone-field
    python-crontab
=======
    cron-descriptor
    python-crontab
    celery
    django-timezone-field
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    tzdata
  ];

  nativeCheckInputs = [
    ephem
<<<<<<< HEAD
    pytest-django
    pytest-timeout
=======
    pytest-timeout
    pytest-django
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Connection error
    "t/unit/test_schedulers.py"
  ];

<<<<<<< HEAD
  disabledTests = [
    # AssertionError: 'At 02:00, only on Monday UTC' != 'At 02:00 AM, only on Monday UTC'
    "test_long_name"
  ];

  pythonImportsCheck = [ "django_celery_beat" ];

  meta = {
    description = "Celery Periodic Tasks backed by the Django ORM";
    homepage = "https://github.com/celery/django-celery-beat";
    changelog = "https://github.com/celery/django-celery-beat/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
=======
  pythonImportsCheck = [ "django_celery_beat" ];

  meta = with lib; {
    description = "Celery Periodic Tasks backed by the Django ORM";
    homepage = "https://github.com/celery/django-celery-beat";
    changelog = "https://github.com/celery/django-celery-beat/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
