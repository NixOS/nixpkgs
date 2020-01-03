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
  version = "0.42.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "48cb522c1c993e238bfe272fbb18049cbd4bf5b9d6c0d4a4fa113cc790e8196c";
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
