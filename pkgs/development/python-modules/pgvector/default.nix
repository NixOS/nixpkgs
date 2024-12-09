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
  postgresql,
  postgresqlTestHook,
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
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ho0UgamZxsN+pv7QkpsDnN7f+I+SrexA2gVtmJF8/3Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    asyncpg
    django
    peewee
    psycopg
    psycopg2
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
  };

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
