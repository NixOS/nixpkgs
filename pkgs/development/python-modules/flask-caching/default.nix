{ lib, buildPythonPackage, fetchPypi, flask, pytest, pytestcov, pytest-xprocess, pytestcache }:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d0bd13c448c1640334131ed4163a12aff7df2155e73860f07fc9e5e75de7126";
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
