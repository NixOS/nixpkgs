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
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.45.0";
  format = "flit";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = version;
    sha256 = "1qwh382ny6qa3zi64micdq4j7dc64zv4rfd8g91j0digd4rhs6i1";
  };

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
  ];

  # starlette pinning kept in place due to 0.12.9 being a hard
  # dependency luckily fastapi is currently the only dependent on
  # starlette. Please remove pinning when possible
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pydantic >=0.32.2,<=0.32.2" "pydantic"
  '';

  checkPhase = ''
    pytest --ignore=tests/test_default_response_class.py
  '';

  meta = with lib; {
    homepage = "https://github.com/tiangolo/fastapi";
    description = "FastAPI framework, high performance, easy to learn, fast to code, ready for production";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
