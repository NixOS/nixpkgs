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
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zyegfryed";
    repo = "django-statici18n";
    rev = "refs/tags/v${version}";
    hash = "sha256-n6HqHcXvz2ihwN+gJr5P+/Yt4RpuOu2yAjo9fiNZB54=";
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
      greizgh
      schmittlauch
    ];
  };
}
