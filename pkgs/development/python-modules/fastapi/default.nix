{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonRelaxDepsHook,

  # build-system
  hatchling,

  # dependencies
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
  version = "0.110.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = "refs/tags/${version}";
    hash = "sha256-qUh5exkXVRcKIO0t4KIOZhhpsftj3BrWaL2asf8RqUI=";
  };

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "anyio"
    # https://github.com/tiangolo/fastapi/pull/9636
    "starlette"
  ];

  propagatedBuildInputs = [
    starlette
    pydantic
    typing-extensions
  ];

  passthru.optional-dependencies.all =
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
  ] ++ passthru.optional-dependencies.all ++ python-jose.optional-dependencies.cryptography;

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
