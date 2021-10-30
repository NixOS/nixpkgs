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
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.70.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = version;
    sha256 = "sha256-mLI+w9PeewnwUMuUnXj6J2r/3shinjlwXMnhNcQlhrM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "starlette ==" "starlette >="
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
  ];

  # disabled tests require orjson which requires rust nightly

  # ignoring deprecation warnings to avoid test failure from
  # tests/test_tutorial/test_testing/test_tutorial001.py

  pytestFlagsArray = [
    "--ignore=tests/test_default_response_class.py"
    "-W ignore::DeprecationWarning"
  ];

  disabledTests = [
    "test_get_custom_response"

    # Failed: DID NOT RAISE <class 'starlette.websockets.WebSocketDisconnect'>
    "test_websocket_invalid_data"
    "test_websocket_no_credentials"
  ];

  meta = with lib; {
    homepage = "https://github.com/tiangolo/fastapi";
    description = "FastAPI framework, high performance, easy to learn, fast to code, ready for production";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
