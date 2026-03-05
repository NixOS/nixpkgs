{
  appdirs,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  mysqlclient,
  nix-update-script,
  psycopg2,
  postgresql,
  postgresqlTestHook,
  setuptools,
  toml,
  unittestCheckHook,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "django-migration-linter";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3YOURMIND";
    repo = "django-migration-linter";
    tag = "v${version}";
    hash = "sha256-cicDAD3KZoU6UG+T/4BBv4nPMJf2gFT8+sAGOFVCV5Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    appdirs
    toml
  ];

  env = {
    PGUSER = "postgres";
    PGDATABASE = "django_migration_linter_test_project";
  };

  prePatch = builtins.concatStringsSep "\n" [
    # these two tests use django_add_default_value, which will be obsolete soon
    ''
      substituteInPlace tests/test_project/settings.py --replace-fail '"tests.test_project.app_add_not_null_column_followed_by_default",' ""
      substituteInPlace tests/test_project/settings.py --replace-fail '"tests.test_project.app_make_not_null_with_lib_default",' ""
    ''
    # these tests require a running mysql server
    "rm tests/unit/test_sql_analyser.py tests/unit/test_linter.py tests/functional/test_cache.py tests/functional/test_migration_linter.py tests/functional/test_makemigrations_command.py"
  ];

  checkPhase = ''
    runHook preCheck

    python manage.py test --no-input

    runHook postCheck
  '';

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
    unittestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.test;
  optional-dependencies = {
    test = [
      mysqlclient
      psycopg2
    ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Detect backward incompatible migrations for your Django project";
    homepage = "https://github.com/3YOURMIND/django-migration-linter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/3YOURMIND/django-migration-linter/releases/tag/${src.tag}";
  };
}
