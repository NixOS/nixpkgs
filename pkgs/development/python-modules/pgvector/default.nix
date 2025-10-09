{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  asyncpg,
  django,
  peewee,
  pg8000,
  postgresql,
  postgresqlTestHook,
  psycopg-pool,
  psycopg,
  psycopg2,
  pytest-asyncio,
  pytestCheckHook,
  scipy,
  sqlalchemy,
  sqlmodel,
}:

buildPythonPackage rec {
  pname = "pgvector";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector-python";
    tag = "v${version}";
    hash = "sha256-QbNzEQctKgxdH1cpMmf2Yg05Q3KOT9tGtK4YSr9GiC4=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    asyncpg
    django
    peewee
    pg8000
    psycopg
    psycopg.pool
    psycopg2
    psycopg-pool
    (postgresql.withPackages (p: with p; [ pgvector ]))
    postgresqlTestHook
    pytest-asyncio
    pytestCheckHook
    scipy
    sqlalchemy
    sqlmodel
  ];

  env = {
    PGDATABASE = "pgvector_python_test";
    postgresqlEnableTCP = 1;
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    USER = "test_user";
  };

  disabledTestPaths = [
    # DB error
    "tests/test_pg8000.py"
    "tests/test_sqlalchemy.py"
  ];

  pythonImportsCheck = [ "pgvector" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Pgvector support for Python";
    homepage = "https://github.com/pgvector/pgvector-python";
    changelog = "https://github.com/pgvector/pgvector-python/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
