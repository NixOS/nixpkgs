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
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
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
  version = "0.112.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = "refs/tags/${version}";
    hash = "sha256-M09yte0BGC5w3AZSwDUr9qKUrotqVklO8mwyms9B95Y=";
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
    pyjwt
    pytestCheckHook
    pytest-asyncio
    trio
    sqlalchemy
  ] ++ optional-dependencies.all;

  pytestFlagsArray = [
    # ignoring deprecation warnings to avoid test failure from
    # tests/test_tutorial/test_testing/test_tutorial001.py
    "-W ignore::DeprecationWarning"
    "-W ignore::pytest.PytestUnraisableExceptionWarning"
  ];

  disabledTests = [
    # Coverage test
    "test_fastapi_cli"
    # ResourceWarning: Unclosed <MemoryObjectSendStream>
    "test_openapi_schema"
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
