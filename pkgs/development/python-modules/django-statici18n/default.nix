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
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zyegfryed";
    repo = "django-statici18n";
    tag = "v${version}";
    hash = "sha256-t3Spxs+A+iQ0+F3eCIE0Ym8wxZE6oZPsl7bFSwA2B0Y=";
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

  meta = {
    description = "Helper for generating Javascript catalog to static files";
    homepage = "https://github.com/zyegfryed/django-statici18n";
    license = lib.licenses.bsd3;
    maintainers = [
    ];
  };
}
