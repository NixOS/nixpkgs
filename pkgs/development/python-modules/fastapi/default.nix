{ lib
, buildPythonPackage
, fetchFromGitHub
, uvicorn
, starlette
, pydantic
, isPy3k
, pytest
, pytestcov
, pyjwt
, passlib
, aiosqlite
, peewee
, flask
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.55.1";
  format = "flit";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = version;
    sha256 = "1515nhwari48v0angyl5z3cfpvwn4al2nvqh0cjd9xgxzvm310s8";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "starlette ==0.13.2" "starlette"
  '';

  propagatedBuildInputs = [
    uvicorn
    starlette
    pydantic
  ];

  checkInputs = [
    pytest
    pytestcov
    pyjwt
    passlib
    aiosqlite
    peewee
    flask
  ];

  # test_default_response_class.py: requires orjson, which requires rust toolchain
  # test_custom_response/test_tutorial001b.py: requires orjson
  # tests/test_tutorial/test_sql_databases/test_testing_databases.py: just broken, don't know why
  checkPhase = ''
    pytest --ignore=tests/test_default_response_class.py \
           --ignore=tests/test_tutorial/test_custom_response/test_tutorial001b.py \
           --ignore=tests/test_tutorial/test_sql_databases/test_testing_databases.py
  '';

  meta = with lib; {
    homepage = "https://github.com/tiangolo/fastapi";
    description = "FastAPI framework, high performance, easy to learn, fast to code, ready for production";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
