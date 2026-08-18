{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  django-appconf,
  celery,
  pytest-django,
  pytest,
  python,
}:

buildPythonPackage rec {
  pname = "django-celery-email";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pmclanahan";
    repo = "django-celery-email";
    rev = version;
    hash = "sha256-LBavz5Nh2ObmIwLCem8nHvsuKgPwkzbS/OzFPmSje/M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-appconf
    celery
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytest
  ];

  pytestFlags = [ "tests/tests.py" ];

  # Don't use pytestCheckHook since tests need to override the django `EMAIL_BACKEND` which can only be done in python
  checkPhase = ''
    ${python.executable} runtests.py
  '';

  pythonImportsCheck = [ "djcelery_email" ];

  meta = {
    homepage = "https://github.com/pmclanahan/django-celery-email";
    description = "Django email backend that uses a celery task for sending the email";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
