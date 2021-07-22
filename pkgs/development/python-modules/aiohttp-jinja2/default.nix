{ lib, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp, pytest-cov }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c22a0e48e3b277fc145c67dd8c3b8f609dab36bce9eb337f70dfe716663c9a0";
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
