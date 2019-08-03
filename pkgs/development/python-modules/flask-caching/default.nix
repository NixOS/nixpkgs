{ lib, buildPythonPackage, fetchPypi, flask, pytest, pytestcov, pytest-xprocess }:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17jnnmnpdflv120yhsfbnpick06iias6f2hcxmf1mi1nr35kdqjj";
  };

  propagatedBuildInputs = [ flask ];

  checkInputs = [ pytest pytestcov pytest-xprocess ];

  # backend_cache relies on pytest-cache, which is a stale package from 2013
  checkPhase = ''
    pytest -k 'not backend_cache'
  '';

  meta = with lib; {
    description = "Adds caching support to your Flask application";
    homepage = "https://github.com/sh4nks/flask-caching";
    license = licenses.bsd3;
  };
}
