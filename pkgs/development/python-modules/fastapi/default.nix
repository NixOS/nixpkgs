{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
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
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.49.0";
  format = "flit";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi";
    rev = version;
    sha256 = "1dw5f2xvn0fqqsy29ypba8v3444cy7dvc7gkpmnhshky0rmfni3n";
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
    peewee
  ];

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
