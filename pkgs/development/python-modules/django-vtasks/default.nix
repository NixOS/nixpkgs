{
  lib,
  buildPythonPackage,
  croniter,
  dj-database-url,
  django-valkey,
  django-vcache,
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
  pyzstd,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "django-vtasks";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-vtasks";
    tag = "v${version}";
    hash = "sha256-f9x6atPMYgQQ/jpCJdDj33l+mhyei+6IWi4bqqVWxU8=";
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
  ];

  optional-dependencies = {
    metrics = [ prometheus-client ];
    valkey = [ django-vcache ] ++ lib.optional (pythonOlder "3.14") pyzstd;
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
    django-vcache
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
