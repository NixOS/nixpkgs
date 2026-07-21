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
  httpx2,
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

buildPythonPackage (finalAttrs: {
  pname = "fastapi";
  version = "0.139.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    tag = finalAttrs.version;
    hash = "sha256-c4balkkmBv7zKRQnYRpRohVjP23m0HvtdiVrJtgNKYo=";
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
    httpx2
    inline-snapshot
    pwdlib
    pyjwt
    pytestCheckHook
    pytest-xdist
    pytest-timeout
  ]
  ++ anyio.optional-dependencies.trio
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.all;

  disabledTests = [
    # Coverage test
    "test_fastapi_cli"
  ];

  disabledTestPaths = [
    # Don't test docs and examples
    "docs_src"
    "tests/test_tutorial"
    # Infinite recursion with strawberry-graphql
    "tests/test_tutorial/test_graphql/test_tutorial001.py"
  ];

  pythonImportsCheck = [ "fastapi" ];

  meta = {
    changelog = "https://github.com/fastapi/fastapi/releases/tag/${finalAttrs.src.tag}";
    description = "Web framework for building APIs";
    homepage = "https://github.com/fastapi/fastapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
})
