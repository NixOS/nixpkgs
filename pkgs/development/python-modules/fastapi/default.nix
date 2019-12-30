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
  version = "0.45.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "44712863ca3899eb812a6869a2efe02d6be6ae972968c76a43d82ec472788f17";
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
