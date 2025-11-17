{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  django-appconf,
  celery,
  pytest-django,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "django-celery-email";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pmclanahan";
    repo = "django-celery-email";
    rev = version;
    hash = "sha256-LBavz5Nh2ObmIwLCem8nHvsuKgPwkzbS/OzFPmSje/M=";
  };

  propagatedBuildInputs = [
    django
    django-appconf
    celery
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  checkPhase = ''
    ${python.executable} runtests.py
  '';

  pythonImportsCheck = [ "djcelery_email" ];

  meta = with lib; {
    homepage = "https://github.com/pmclanahan/django-celery-email";
    description = "Django email backend that uses a celery task for sending the email";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
