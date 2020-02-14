{ lib, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dfe29cfd278d07cd0a851afb98471bc8ce2a830968443e40d67636f3c035d79";
  };

  propagatedBuildInputs = [ aiohttp jinja2 ];

  checkInputs = [ pytest pytest-aiohttp ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = https://github.com/aio-libs/aiohttp_jinja2;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
