{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pdm-backend,

  # dependencies
  fastapi-cli,
  starlette,
  pydantic,
  typing-extensions,

  # tests
  dirty-equals,
  flask,
  passlib,
  pytest-asyncio,
  pytestCheckHook,
  python-jose,
  sqlalchemy,
  trio,

  # optional-dependencies
  httpx,
  jinja2,
  python-multipart,
  itsdangerous,
  pyyaml,
  ujson,
  orjson,
  email-validator,
  uvicorn,
  pydantic-settings,
  pydantic-extra-types,
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.111.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = "refs/tags/${version}";
    hash = "sha256-DQYjK1dZuL7cF6quyNkgdd/GYmWm7k6YlF7YEjObQlI=";
  };

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    "anyio"
    "starlette"
  ];

  dependencies = [
    fastapi-cli
    starlette
    pydantic
    typing-extensions
  ];

  optional-dependencies.all =
    [
      httpx
      jinja2
      python-multipart
      itsdangerous
      pyyaml
      ujson
      orjson
      email-validator
      uvicorn
    ]
    ++ lib.optionals (lib.versionAtLeast pydantic.version "2") [
      pydantic-settings
      pydantic-extra-types
    ]
    ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = [
    dirty-equals
    flask
    passlib
    pytestCheckHook
    pytest-asyncio
    python-jose
    trio
    sqlalchemy
  ] ++ optional-dependencies.all ++ python-jose.optional-dependencies.cryptography;

  pytestFlagsArray = [
    # ignoring deprecation warnings to avoid test failure from
    # tests/test_tutorial/test_testing/test_tutorial001.py
    "-W ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # Don't test docs and examples
    "docs_src"
    # databases is incompatible with SQLAlchemy 2.0
    "tests/test_tutorial/test_async_sql_databases"
    "tests/test_tutorial/test_sql_databases"
  ];

  pythonImportsCheck = [ "fastapi" ];

  meta = with lib; {
    changelog = "https://github.com/tiangolo/fastapi/releases/tag/${version}";
    description = "Web framework for building APIs";
    homepage = "https://github.com/tiangolo/fastapi";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
