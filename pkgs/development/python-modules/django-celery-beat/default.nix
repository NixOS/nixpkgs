{ lib
, fetchPypi
, buildPythonPackage
, python-crontab
, celery
, django-timezone-field
, tzdata
, ephem
, pytest-timeout
, pytest-django
, case
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "django-celery-beat";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uiT4btlWug7itDI3pJMD6/Wqfg+wzLfgVCt+MaRj3Lo=";
  };

  propagatedBuildInputs = [
    python-crontab
    celery
    django-timezone-field
    tzdata
  ];

  checkInputs = [
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
