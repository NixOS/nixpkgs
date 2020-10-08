{ lib, buildPythonPackage, fetchPypi, isPy27, flask, pytest, pytestcov, pytest-xprocess, pytestcache }:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "1.9.0";
  disabled = isPy27; # invalid python2 syntax

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0356ad868b1d8ec2d0e675a6fe891c41303128f8904d5d79e180d8b3f952aff";
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
