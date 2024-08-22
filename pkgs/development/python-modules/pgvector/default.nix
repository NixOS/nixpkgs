{
  lib,
  asyncpg,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  numpy,
  peewee,
  postgresql,
  postgresqlTestHook,
  psycopg,
  psycopg2,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools,
  sqlalchemy,
  sqlmodel,
}:

buildPythonPackage rec {
  pname = "pgvector";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-8F2tNUtRgeIK/1utkbL+xF/bTlJxvhn+RxerpGMUP/k=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    asyncpg
    django
    peewee
    (postgresql.withPackages (p: with p; [ pgvector ]))
    postgresqlTestHook
    psycopg
    psycopg2
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

  meta = with lib; {
    description = "Pgvector support for Python";
    homepage = "https://github.com/pgvector/pgvector-python";
    changelog = "https://github.com/pgvector/pgvector-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
