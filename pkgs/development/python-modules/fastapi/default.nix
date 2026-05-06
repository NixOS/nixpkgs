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
  typing-inspection,

  # tests
  anyio,
  a2wsgi,
  dirty-equals,
  flask,
  inline-snapshot,
  pwdlib,
  pyjwt,
  pytest-xdist,
  pytest-timeout,
  pytestCheckHook,

  # optional-dependencies
  fastapi-cli,
  httpx,
  jinja2,
  itsdangerous,
  python-multipart,
  pyyaml,
  email-validator,
  uvicorn,
  pydantic-settings,
  pydantic-extra-types,
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.136.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    tag = version;
    hash = "sha256-0NMMCwmV9teA0QfwdKoXKLN9Oj7EZ53Z7EluQ+8/FbE=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    annotated-doc
    starlette
    pydantic
    typing-extensions
    typing-inspection
  ];

  optional-dependencies = {
    all = [
      fastapi-cli
      httpx
      jinja2
      python-multipart
      itsdangerous
      pyyaml
      email-validator
      uvicorn
      pydantic-settings
      pydantic-extra-types
    ]
    ++ fastapi-cli.optional-dependencies.standard
    ++ uvicorn.optional-dependencies.standard;
    standard = [
      fastapi-cli
      # FIXME package fastar
      httpx
      jinja2
      python-multipart
      email-validator
      uvicorn
      pydantic-settings
      pydantic-extra-types
    ]
    ++ fastapi-cli.optional-dependencies.standard
    ++ uvicorn.optional-dependencies.standard;
    standard-no-fastapi-cloud-cli = [
      fastapi-cli
      httpx
      jinja2
      python-multipart
      email-validator
      uvicorn
      pydantic-settings
      pydantic-extra-types
    ]
    ++ fastapi-cli.optional-dependencies.standard-no-fastapi-cloud-cli
    ++ uvicorn.optional-dependencies.standard;
  };

  nativeCheckInputs = [
    a2wsgi
    anyio
    a2wsgi
    dirty-equals
    flask
    inline-snapshot
    pwdlib
    pyjwt
    pytestCheckHook
    pytest-xdist
    pytest-timeout
  ]
  ++ anyio.optional-dependencies.trio
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
  ];

  disabledTestPaths = [
    # Don't test docs and examples
    "docs_src"
    "tests/test_tutorial/test_sql_databases"
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
