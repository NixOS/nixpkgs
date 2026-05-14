{
  lib,
  buildPythonPackage,
  croniter,
  dj-database-url,
  django-valkey,
  django,
  fetchFromGitLab,
  hatchling,
  orjson,
  postgresql,
  postgresqlTestHook,
  prometheus-client,
  psycopg,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  redisTestHook,
  valkey,
  zstandard,
}:

buildPythonPackage rec {
  pname = "django-vtasks";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vtasks";
    tag = "v${version}";
    hash = "sha256-75W63HsLBT4EPQCiAXjd9qr6n07/2e5GCUNWeDzXUq0=";
  };

  postPatch = ''
    # upstream does not use pytest to run the tests, but we just need to patch one async test to do so
    substituteInPlace scripts/test_stale_conn.py \
      --replace-fail "import asyncio" "import asyncio; import pytest" \
      --replace-fail "async def test_async_stale_connection():" "@pytest.mark.asyncio
    async def test_async_stale_connection():"
  '';

  build-system = [ hatchling ];

  dependencies = [
    django
    orjson
    croniter
  ]
  ++ lib.optional (pythonOlder "3.14") zstandard;

  optional-dependencies = {
    metrics = [ prometheus-client ];
    valkey = [ valkey ] ++ valkey.optional-dependencies.libvalkey;
  };

  pythonImportsCheck = [ "django_vtasks" ];

  env = {
    DATABASE_URL = "postgresql://postgres@%2Fbuild%2Frun%2Fpostgresql";
    VALKEY_URL = "redis://127.0.0.1:6379";
  };

  nativeCheckInputs = [
    django # must come first as vtasks only works with django 6

    dj-database-url
    django-valkey
    postgresql
    postgresqlTestHook
    psycopg
    pytest-asyncio
    pytest-django
    pytestCheckHook
    redisTestHook # contains valkey
  ];

  meta = {
    description = "Very fast valkey/postgres django tasks backend";
    homepage = "https://gitlab.com/glitchtip/django-vtasks";
    changelog = "https://gitlab.com/glitchtip/django-vtasks/-/releases/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
    broken = lib.versionOlder (lib.versions.major django.version) "6";
  };
}
