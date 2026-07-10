{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  alembic,
  asyncpg,
  bcrypt,
  celery,
  email-validator,
  fastapi,
  flowsint,
  flowsint-core,
  flowsint-types,
  jsonschema,
  mistralai,
  neo4j,
  networkx,
  openpyxl,
  passlib,
  psycopg2,
  pydantic,
  python-dotenv,
  python-jose,
  python-multipart,
  redis,
  requests,
  sqlalchemy,
  sse-starlette,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowsint-api";
  pyproject = true;

  inherit (flowsint) src version;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  pythonRelaxDeps = [
    "alembic"
    "asyncpg"
    "bcrypt"
    "cryptography"
    "fastapi"
    "jsonschema"
    "mistralai"
    "neo4j"
    "networkx"
    "python-multipart"
    "redis"
    "sse-starlette"
    "uvicorn"
  ];

  pythonRemoveDeps = [
    # Circular dependency
    "flowsint-enrichers"
    "psycopg2-binary"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    alembic
    bcrypt
    celery
    email-validator
    fastapi
    flowsint-core
    flowsint-types
    jsonschema
    mistralai
    neo4j
    networkx
    openpyxl
    passlib
    psycopg2
    pydantic
    python-dotenv
    python-jose
    redis
    requests
    sqlalchemy
    sse-starlette
    uvicorn
  ]
  ++ passlib.optional-dependencies.bcrypt
  ++ python-jose.optional-dependencies.cryptography;

  # Circular dependency
  doCheck = false;
  #pythonImportsCheck = [ "flowsint.api" ];

  meta = {
    description = "API server for flowsint";
    homepage = "https://github.com/reconurge/flowsint/blob/main/flowsint-api";
    changelog = "https://github.com/reconurge/flowsint/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
