{
  lib,
  alembic,
  asyncpg,
  bcrypt,
  buildPythonPackage,
  celery,
  cryptography,
  docker,
  fastapi,
  fetchFromGitHub,
  #flowsint-enrichers,
  flowsint,
  flowsint-types,
  neo4j,
  networkx,
  openpyxl,
  passlib,
  phonenumbers,
  poetry-core,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  python-jose,
  python-multipart,
  redis,
  requests,
  sqlalchemy,
  sse-starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowsint-core";
  pyproject = true;

  inherit (flowsint) src version;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  pythonRelaxDeps = [
    "alembic"
    "bcrypt"
    "cryptography"
    "neo4j"
    "networkx"
    "redis"
    "sse-starlette"
  ];

  pythonRemoveDeps = [
    # Circular dependency
    "flowsint-enrichers"
    "psycopg2-binary"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    alembic
    asyncpg
    bcrypt
    celery
    cryptography
    docker
    flowsint-types
    neo4j
    networkx
    openpyxl
    passlib
    phonenumbers
    psycopg2
    pydantic
    python-dotenv
    python-jose
    python-multipart
    redis
    requests
    sqlalchemy
    sse-starlette
  ]
  ++ passlib.optional-dependencies.bcrypt
  ++ pydantic.optional-dependencies.email
  ++ python-jose.optional-dependencies.cryptography;

  nativeCheckInputs = [
    fastapi
    pytest-asyncio
    pytestCheckHook
  ];

  env.AUTH_SECRET = "Test";
  env.REDIS_URL = "redis://localhost";

  pythonImportsCheck = [ "flowsint_core" ];

  disabledTestPaths = [
    # Test requires Neo4j
    "tests/enrichers/test_enricher_base_simplified_api.py"
    "tests/test_enricher_base_simplified_api.py"
    "tests/vault/test_enricher_vault_integration.py"
  ];

  meta = {
    description = "Core utilities and base classes for flowsint modules";
    homepage = "https://github.com/reconurge/flowsint/blob/main/flowsint-core";
    changelog = "https://github.com/reconurge/flowsint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
