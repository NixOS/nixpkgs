{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic
, starlette
, pytestCheckHook
, pytest-asyncio
, aiosqlite
, databases
, flask
, httpx
, passlib
, peewee
, python-jose
, sqlalchemy
, trio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.79.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HaA9a/tqKtB24YtObk/XAsUy2mmWNonRyPXHflGRiPQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "starlette==" "starlette>="
  '';

  propagatedBuildInputs = [
    starlette
    pydantic
  ];

  checkInputs = [
    aiosqlite
    databases
    flask
    httpx
    passlib
    peewee
    python-jose
    pytestCheckHook
    pytest-asyncio
    sqlalchemy
    trio
  ] ++ passlib.optional-dependencies.bcrypt;

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
