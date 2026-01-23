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
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector-python";
    tag = "v${version}";
    hash = "sha256-jzUZK3zQxqajVqGbaQzLPzvK/k3Wck9jX95kkBH2IlY=";
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
