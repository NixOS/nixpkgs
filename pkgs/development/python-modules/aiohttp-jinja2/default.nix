{ lib, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp, pytest-cov }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c3ba5eac060b691f4e50534af2d79fca2a75712ebd2b25e6fcb1295859f910b";
  };

  propagatedBuildInputs = [ aiohttp jinja2 ];

  checkInputs = [ pytest pytest-aiohttp pytest-cov ];

  checkPhase = ''
    pytest -W ignore::DeprecationWarning
  '';

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp_jinja2";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
