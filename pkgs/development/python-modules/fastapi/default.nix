{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pdm-backend,

  # dependencies
<<<<<<< HEAD
  annotated-doc,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  starlette,
  pydantic,
  typing-extensions,

  # tests
  anyio,
  dirty-equals,
  flask,
  inline-snapshot,
  passlib,
<<<<<<< HEAD
  pwdlib,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyjwt,
  pytest-asyncio,
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
<<<<<<< HEAD
  version = "0.121.1";
=======
  version = "0.116.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-uUUARIHY8VBoLfWfMvveapypqiB00cTTWpJ4fi9nvUo=";
=======
    hash = "sha256-sd0SnaxuuF3Zaxx7rffn4ttBpRmWQoOtXln/amx9rII=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    "anyio"
    "starlette"
  ];

  dependencies = [
<<<<<<< HEAD
    annotated-doc
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    dirty-equals
    flask
    inline-snapshot
    passlib
<<<<<<< HEAD
    pwdlib
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pyjwt
    pytestCheckHook
    pytest-asyncio
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
  ];

  pythonImportsCheck = [ "fastapi" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/fastapi/fastapi/releases/tag/${src.tag}";
    description = "Web framework for building APIs";
    homepage = "https://github.com/fastapi/fastapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
=======
  meta = with lib; {
    changelog = "https://github.com/fastapi/fastapi/releases/tag/${src.tag}";
    description = "Web framework for building APIs";
    homepage = "https://github.com/fastapi/fastapi";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
