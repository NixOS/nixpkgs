{ lib
, buildPythonPackage
, fetchPypi
, uvicorn
, starlette
, pydantic
, python
, isPy3k
, which
}:

buildPythonPackage rec {
  pname = "fastapi";
  version = "0.33.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mc8ljfk6xyn2cq725s8hgapp62z5mylzw9akvkhwwz3bh8m5a7f";
  };

  propagatedBuildInputs = [
    uvicorn
    starlette
    pydantic
  ];

  patches = [ ./setup.py.patch ];

  checkPhase = ''
    ${python.interpreter} -c "from fastapi import FastAPI; app = FastAPI()"
  '';

  meta = with lib; {
    homepage = "https://github.com/tiangolo/fastapi";
    description = "FastAPI framework, high performance, easy to learn, fast to code, ready for production";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
