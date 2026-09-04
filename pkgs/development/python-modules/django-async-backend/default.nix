{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  libcst,
  poetry-core,
  postgresql,
  postgresqlTestHook,
  psycopg,
  psycopg-pool,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-async-backend";
  version = "6.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Arfey";
    repo = "django-async-backend";
    tag = "v${version}";
    hash = "sha256-pfcqTtyV37bZFSZaRcFIt9cgR8XZ7PDijVC18lMziRU=";
  };

  postPatch = ''
    substituteInPlace tests/settings.py \
      --replace-fail '"HOST": "localhost"' '"HOST": "/build/run/postgresql"'

    substituteInPlace tests/db/backends/postgresql/test_async_backend.py \
      --replace-fail "new_connection.get_database_version())[0], 15" "new_connection.get_database_version())[0], ${lib.versions.major postgresql.version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    django
    psycopg
  ];

  pythonImportsCheck = [ "django_async_backend" ];

  env = {
    DJANGO_SETTINGS_MODULE = "settings";
    PGDATABASE = "postgres";
    PGUSER = "postgres";
  };

  checkPhase = ''
    runHook preCheck

    cd tests/
    python manage.py test

    runHook postCheck
  '';

  nativeCheckInputs = [
    django # must come first as vtasks only works with django 6

    libcst
    postgresql
    postgresqlTestHook
    psycopg-pool
  ];

  meta = {
    description = "True async Django ORM and PostgreSQL backend with connection pooling and async transactions";
    homepage = "https://github.com/Arfey/django-async-backend";
    changelog = "https://github.com/Arfey/django-async-backend/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    broken = lib.versionOlder (lib.versions.major django.version) "6";
  };
}
