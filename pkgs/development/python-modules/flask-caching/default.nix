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
  version = "1.11.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28af189e97defb9e39b43ebe197b54a58aaee81bdeb759f46d969c26d7aa7810";
  };

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
