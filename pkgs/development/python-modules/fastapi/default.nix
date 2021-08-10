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
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.68.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = version;
    sha256 = "00cjkc90h0qlca30g981zvwlxh2wc3rfipw25v667jdl9x5gxv9p";
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
  ];

  # disabled tests require orjson which requires rust nightly

  # ignoring deprecation warnings to avoid test failure from
  # tests/test_tutorial/test_testing/test_tutorial001.py

  pytestFlagsArray = [ "--ignore=tests/test_default_response_class.py" "-W ignore::DeprecationWarning"];
  disabledTests = [ "test_get_custom_response" ];

  meta = with lib; {
    homepage = "https://github.com/tiangolo/fastapi";
    description = "FastAPI framework, high performance, easy to learn, fast to code, ready for production";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
