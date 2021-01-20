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
  version = "0.63.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = version;
    sha256 = "0l3imrcs42pqf9d6k8c1q15k5sqcnapl5zk71xl52mrxhz49lgpi";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "starlette ==0.13.6" "starlette"
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
  pytestFlagsArray = [ "--ignore=tests/test_default_response_class.py" ];
  disabledTests = [ "test_get_custom_response" ];

  meta = with lib; {
    homepage = "https://github.com/tiangolo/fastapi";
    description = "FastAPI framework, high performance, easy to learn, fast to code, ready for production";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
