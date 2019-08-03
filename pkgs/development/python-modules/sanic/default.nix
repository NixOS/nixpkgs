{ lib
, buildPythonPackage
, fetchPypi
, httptools
, aiofiles
, websockets
, multidict
, uvloop
, ujson
, pytest
, gunicorn
, pytestcov
, aiohttp
, beautifulsoup4
, pytest-sanic
, pytest-sugar
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "19.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce434eb154872ca64493a6c3a288f11fd10bca0de7be7bf9f1d0d063185e51ec";
  };

  propagatedBuildInputs = [
    httptools
    aiofiles
    websockets
    multidict
    uvloop
    ujson
  ];

  checkInputs = [
    pytest
    gunicorn
    pytestcov
    aiohttp
    beautifulsoup4
    pytest-sanic
    pytest-sugar
    pytest-benchmark
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "websockets>=6.0,<7.0" "websockets"
  '';

  # 10/500 tests ignored due to missing directory and
  # requiring network access
  checkPhase = ''
    pytest --ignore tests/test_blueprints.py \
           --ignore tests/test_routes.py \
           --ignore tests/test_worker.py
  '';

  meta = with lib; {
    description = "A microframework based on uvloop, httptools, and learnings of flask";
    homepage = http://github.com/channelcat/sanic/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
