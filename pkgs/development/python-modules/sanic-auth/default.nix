{ lib, buildPythonPackage, fetchPypi, pytest, sanic }:

buildPythonPackage rec {
  pname = "Sanic-Auth";
  version = "0.2.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "b7cb9e93296c035ada0aa1ebfb33f9f7b62f7774c519e374b7fe703ff73589cb";
  };
  
  propagatedBuildInputs = [ sanic ];
  
  checkInputs = [ pytest ];
  
  checkPhase = ''
    pytest tests
  '';
  
  meta = with lib; {
    description = "Simple Authentication for Sanic";
    homepage = "https://github.com/pyx/sanic-auth/";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
