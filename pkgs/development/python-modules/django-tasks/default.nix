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
  django-rq,
  fakeredis,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-tasks";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RealOrangeOne";
    repo = "django-tasks";
    tag = version;
    hash = "sha256-fXXqPmpyIq+66okWDmTIBaoaslY8BSILXjJWn8cXnMM=";
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
    django-rq
    fakeredis
    pytestCheckHook
    pytest-django
  ];

  disabledTests = [
    # AssertionError: Lists differ: [] != ['Starting worker for queues=default', ...
    "test_verbose_logging"
    # AssertionError: '' != 'Deleted 0 task result(s)'
    "test_doesnt_prune_new_task"
    # AssertionError: '' != 'Would delete 1 task result(s)'
    "test_dry_run"
    # AssertionError: '' != 'Deleted 1 task result(s)'
    "test_prunes_tasks"
    # AssertionError: 'Run maximum tasks (2)' not found in ''
    "test_max_tasks"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="tests.settings"
  '';

  meta = {
    description = "Reference implementation and backport of background workers and tasks in Django";
    homepage = "https://github.com/RealOrangeOne/django-tasks";
    changelog = "https://github.com/RealOrangeOne/django-tasks/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
