{ lib, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g4pqdm2kp2abam0nx0pgs5lk19f8lsfpcgwxpigdwmy1lvblsa5";
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
