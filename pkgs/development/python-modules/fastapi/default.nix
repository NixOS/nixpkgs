{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

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
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.103.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2J8c3S4Ca+c5bI0tyjMJArJKux9qPmu+ohqve5PhSGI=";
  };

  nativeBuildInputs = [
    hatchling
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
    # pydantic-settings
    # pydantic-extra-types
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
  ] ++ passthru.optional-dependencies.all;

  pytestFlagsArray = [
    # ignoring deprecation warnings to avoid test failure from
    # tests/test_tutorial/test_testing/test_tutorial001.py
    "-W ignore::DeprecationWarning"
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
