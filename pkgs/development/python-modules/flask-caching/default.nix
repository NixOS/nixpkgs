{ lib, buildPythonPackage, fetchPypi, isPy27, flask, pytest, pytestcov, pytest-xprocess, pytestcache }:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "1.10.1";
  disabled = isPy27; # invalid python2 syntax

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf19b722fcebc2ba03e4ae7c55b532ed53f0cbf683ce36fafe5e881789a01c00";
  };

  propagatedBuildInputs = [ flask ];

  checkInputs = [ pytest pytestcov pytest-xprocess pytestcache ];

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
