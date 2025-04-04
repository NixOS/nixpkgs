{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  django-stubs-ext,
  typing-extensions,
  coverage,
  dj-database-url,
  django-stubs,
  ruff,
  mysqlclient,
  psycopg,
}:

buildPythonPackage rec {
  pname = "django-tasks";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "RealOrangeOne";
    repo = "django-tasks";
    rev = version;
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
    dev = [
      coverage
      dj-database-url
      django-stubs
      ruff
    ];
    mysql = [
      mysqlclient
    ];
    postgres = [
      psycopg
    ];
  };

  pythonImportsCheck = [
    "django_tasks"
  ];

  meta = {
    description = "A reference implementation and backport of background workers and tasks in Django";
    homepage = "https://github.com/RealOrangeOne/django-tasks";
    license = lib.licenses.bsd3;
  };
}
