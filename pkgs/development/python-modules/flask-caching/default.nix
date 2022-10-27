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
  version = "2.0.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EN8gCgPwMq9gB3vv5Bd53ZSJi2fIIEDTTochC3G6Jjg=";
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
