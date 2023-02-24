{ lib
, stdenv
, buildPythonPackage
, cachelib
, fetchPypi
, flask
, pytest-asyncio
, pytest-xprocess
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JLYMVS1ZqWBcwbakLFbNs5qCoo2rRTK77bkiKuVOy04=";
  };

  propagatedBuildInputs = [
    cachelib
    flask
  ] ++ flask.optional-dependencies.async;

  nativeCheckInputs = [
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
  ] ++ lib.optionals stdenv.isDarwin [
    # ignore flaky test
    "test_cached_view_class"
  ];

  meta = with lib; {
    description = "A caching extension for Flask";
    homepage = "https://github.com/pallets-eco/flask-caching";
    changelog = "https://github.com/pallets-eco/flask-caching/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
