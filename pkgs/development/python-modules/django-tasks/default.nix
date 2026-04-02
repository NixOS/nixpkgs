{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  django-stubs-ext,
  typing-extensions,

  # optional-dependencies
  mysqlclient,
  psycopg,

  # tests
  dj-database-url,
  django-rq,
  fakeredis,
  pytestCheckHook,
  pytest-django,
  redisTestHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-tasks";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RealOrangeOne";
    repo = "django-tasks";
    tag = finalAttrs.version;
    hash = "sha256-pAVpsQXoiqneQaXrHNbBW7LumyYeJ4/9b0dg2qx7LZo=";
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

  # redis hook does not support darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    django-rq
    dj-database-url
    fakeredis
    pytestCheckHook
    pytest-django
    redisTestHook
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
    # AssertionError: <django_tasks.backends.database.backend.DatabaseBackend object at 0x7ffff3fa3cd0> is not an instance of <class 'django_tasks.backends.immediate.ImmediateBackend'>
    "test_uses_lib_tasks_by_default"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="tests.settings"
  '';

  meta = {
    description = "Reference implementation and backport of background workers and tasks in Django";
    homepage = "https://github.com/RealOrangeOne/django-tasks";
    changelog = "https://github.com/RealOrangeOne/django-tasks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
