{ lib, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aef9b6595f962182ad00c990095fb51d731c280e1d183e2b28cf0bdb5a942d0c";
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
