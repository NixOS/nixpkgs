{ lib, stdenv, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ps182yrc5g9ph55927a7ssqx6m9kx0bivfxpaj8sa3znrdkl94d";
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
