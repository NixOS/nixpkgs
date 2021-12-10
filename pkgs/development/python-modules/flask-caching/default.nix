{ lib, buildPythonPackage, fetchFromGitHub, isPy27, flask, pytestCheckHook, pytest-cov, pytest-xprocess, pytestcache }:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "1.10.1";
  disabled = isPy27; # invalid python2 syntax

  src = fetchFromGitHub {
     owner = "sh4nks";
     repo = "flask-caching";
     rev = "v1.10.1";
     sha256 = "038zrahcn7lm5y9v532kc7abiwypb39s0g6kz6pbrrdw700s3y84";
  };

  propagatedBuildInputs = [ flask ];

  checkInputs = [ pytestCheckHook pytest-cov pytest-xprocess pytestcache ];

  disabledTests = [
    # backend_cache relies on pytest-cache, which is a stale package from 2013
    "backend_cache"
    # optional backends
    "Redis"
    "Memcache"
  ];

  meta = with lib; {
    description = "Adds caching support to your Flask application";
    homepage = "https://github.com/sh4nks/flask-caching";
    license = licenses.bsd3;
  };
}
