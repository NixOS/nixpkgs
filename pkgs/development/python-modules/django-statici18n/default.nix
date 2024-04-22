{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, django
, django-appconf

# tests
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-statici18n";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zyegfryed";
    repo = "django-statici18n";
    # https://github.com/zyegfryed/django-statici18n/issues/59
    rev = "9b83a8f0f2e625dd5f56d53cfe4e07aca9479ab6";
    hash = "sha256-KrIlWmN7um9ad2avfANOza579bjYkxTo9F0UFpvLu3A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    django-appconf
  ];

  pythonImportsCheck = [
    "statici18n"
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.test_project.project.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Helper for generating Javascript catalog to static files";
    homepage = "https://github.com/zyegfryed/django-statici18n";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
