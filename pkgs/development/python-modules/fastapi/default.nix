{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook

# build-system
, hatchling

# dependencies
, starlette
, pydantic
, typing-extensions

# tests
, dirty-equals
, flask
, passlib
, pytest-asyncio
, pytestCheckHook
, python-jose
, sqlalchemy
, trio

# optional-dependencies
, httpx
, jinja2
, python-multipart
, itsdangerous
, pyyaml
, ujson
, orjson
, email-validator
, uvicorn
, pydantic-settings
, pydantic-extra-types
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.104.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xTTFBc+fswLYUhKRkWP/eiYSbG3j1E7CASkEtHVNTlk=";
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

  passthru.optional-dependencies.all = [
    httpx
    jinja2
    python-multipart
    itsdangerous
    pyyaml
    ujson
    orjson
    email-validator
    uvicorn
  ] ++ lib.optionals (lib.versionAtLeast pydantic.version "2") [
    pydantic-settings
    pydantic-extra-types
  ] ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = [
    dirty-equals
    flask
    passlib
    pytestCheckHook
    pytest-asyncio
    python-jose
    trio
    sqlalchemy
  ] ++ passthru.optional-dependencies.all
  ++ python-jose.optional-dependencies.cryptography;

  pytestFlagsArray = [
    # ignoring deprecation warnings to avoid test failure from
    # tests/test_tutorial/test_testing/test_tutorial001.py
    "-W ignore::DeprecationWarning"

    # http code mismatches
    "--deselect=tests/test_annotated.py::test_get"
  ];

  disabledTestPaths = [
    # Disabled tests require orjson which requires rust nightly
    "tests/test_default_response_class.py"
    # Don't test docs and examples
    "docs_src"
    # databases is incompatible with SQLAlchemy 2.0
    "tests/test_tutorial/test_async_sql_databases"
    "tests/test_tutorial/test_sql_databases"
  ];

  disabledTests = [
    "test_get_custom_response"
    # Failed: DID NOT RAISE <class 'starlette.websockets.WebSocketDisconnect'>
    "test_websocket_invalid_data"
    "test_websocket_no_credentials"
    # TypeError: __init__() missing 1...starlette-releated
    "test_head"
    "test_options"
    "test_trace"
    # Unexpected number of warnings caught
    "test_warn_duplicate_operation_id"
    # assert state["except"] is True
    "test_dependency_gets_exception"
    # Fixtures drift
    "test_openapi_schema_sub"
    # 200 != 404
    "test_flask"
  ];

  pythonImportsCheck = [
    "fastapi"
  ];

  meta = with lib; {
    description = "Web framework for building APIs";
    homepage = "https://github.com/tiangolo/fastapi";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
