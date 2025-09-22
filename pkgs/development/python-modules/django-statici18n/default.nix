{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  django-appconf,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-statici18n";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zyegfryed";
    repo = "django-statici18n";
    tag = "v${version}";
    hash = "sha256-G1JF/AQEDgvDamvjCYiQM7b6HfbdMBhfEUvT3yL1io0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-appconf
  ];

  pythonImportsCheck = [ "statici18n" ];

  env.DJANGO_SETTINGS_MODULE = "tests.test_project.project.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Helper for generating Javascript catalog to static files";
    homepage = "https://github.com/zyegfryed/django-statici18n";
    license = licenses.bsd3;
    maintainers = with maintainers; [
    ];
  };
}
