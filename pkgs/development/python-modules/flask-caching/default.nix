{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, cachelib
, flask
, pytest-asyncio
, pytest-xprocess
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "2.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MwDvzNo1nWnODmgkuQy1cf+JWjkHwxJmwDQsykvEA0A=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Flask <= 2.1.2" "Flask <= 2.2"
  '';

  propagatedBuildInputs = [
    cachelib
    flask
  ];

  checkInputs = [
    pytest-asyncio
    pytest-xprocess
    pytestCheckHook
  ];

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
