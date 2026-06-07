{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  annotated-doc,
  starlette,
  pydantic,
  typing-extensions,

  # tests
  anyio,
  a2wsgi,
  dirty-equals,
  flask,
  inline-snapshot,
  passlib,
  pwdlib,
  pyjwt,
  pytest-asyncio,
  pytest-xdist,
  pytest-timeout,
  pytestCheckHook,
  sqlalchemy,
  trio,

  # optional-dependencies
  fastapi-cli,
  httpx,
  jinja2,
  itsdangerous,
  python-multipart,
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
  version = "0.135.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    tag = version;
    hash = "sha256-sE5d+MgmP9L+MUosRBsR+KSJkcC9i2EOOtKHq0sXjRM=";
  };

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    "anyio"
    "starlette"
  ];

  dependencies = [
    annotated-doc
    starlette
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    all = [
      fastapi-cli
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
    ++ fastapi-cli.optional-dependencies.standard
    ++ uvicorn.optional-dependencies.standard;
    standard = [
      fastapi-cli
      httpx
      jinja2
      python-multipart
      email-validator
      uvicorn
    ]
    ++ fastapi-cli.optional-dependencies.standard
    ++ uvicorn.optional-dependencies.standard;
  };

  nativeCheckInputs = [
    anyio
    a2wsgi
    dirty-equals
    flask
    inline-snapshot
    passlib
    pwdlib
    pyjwt
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
    pytest-timeout
    trio
    sqlalchemy
  ]
  ++ anyio.optional-dependencies.trio
  ++ passlib.optional-dependencies.bcrypt
  ++ optional-dependencies.all;

  pytestFlags = [
    # ignoring deprecation warnings to avoid test failure from
    # tests/test_tutorial/test_testing/test_tutorial001.py
    "-Wignore::DeprecationWarning"
    "-Wignore::pytest.PytestUnraisableExceptionWarning"
  ];

  disabledTests = [
    # Coverage test
    "test_fastapi_cli"
    # Likely pydantic compat issue
    "test_exception_handler_body_access"
  ];

  disabledTestPaths = [
    # Don't test docs and examples
    "docs_src"
    "tests/test_tutorial/test_sql_databases"
    "tests/test_tutorial/test_static_files"
    "tests/test_tutorial/test_custom_docs_ui"
    # Infinite recursion with strawberry-graphql
    "tests/test_tutorial/test_graphql/test_tutorial001.py"
  ];

  pythonImportsCheck = [ "fastapi" ];

  meta = {
    changelog = "https://github.com/fastapi/fastapi/releases/tag/${src.tag}";
    description = "Web framework for building APIs";
    homepage = "https://github.com/fastapi/fastapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
