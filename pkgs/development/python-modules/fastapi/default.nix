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
  inline-snapshot,
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
  version = "0.115.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = "refs/tags/${version}";
    hash = "sha256-JIaPgZVbz887liVwd3YtubJm+L4tFCM9Jcn9/smjiKo=";
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
    inline-snapshot
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
  ];

  disabledTestPaths = [
    # Don't test docs and examples
    "docs_src"
    "tests/test_tutorial/test_sql_databases"
  ];

  pythonImportsCheck = [ "fastapi" ];

  meta = with lib; {
    changelog = "https://github.com/fastapi/fastapi/releases/tag/${version}";
    description = "Web framework for building APIs";
    homepage = "https://github.com/fastapi/fastapi";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
