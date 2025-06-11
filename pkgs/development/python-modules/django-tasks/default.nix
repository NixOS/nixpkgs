{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  django-stubs-ext,
  typing-extensions,
  mysqlclient,
  psycopg,
  dj-database-url,
  python,
}:

buildPythonPackage rec {
  pname = "django-tasks";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RealOrangeOne";
    repo = "django-tasks";
    tag = version;
    hash = "sha256-MLztM4jVQV2tHPcIExbPGX+hCHSTqaQJeTbQqaVA3V4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    django-stubs-ext
    typing-extensions
  ];

  optional-dependencies = {
    mysql = [
      mysqlclient
    ];
    postgres = [
      psycopg
    ];
  };

  pythonImportsCheck = [ "django_tasks" ];

  nativeCheckInputs = [
    dj-database-url
  ];

  checkPhase = ''
    runHook preCheck

    export DJANGO_SETTINGS_MODULE="tests.settings"
    ${python.interpreter} -m manage test --noinput

    runHook postCheck
  '';

  meta = {
    description = "Reference implementation and backport of background workers and tasks in Django";
    homepage = "https://github.com/RealOrangeOne/django-tasks";
    changelog = "https://github.com/RealOrangeOne/django-tasks/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
