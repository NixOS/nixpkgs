{
  lib,
  stdenv,
  asgiref,
  buildPythonPackage,
  cachelib,
  fetchPypi,
  flask,
  flit-core,
  pytest-asyncio,
  pytest-xprocess,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-caching";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "flask_caching";
    inherit version;
    hash = "sha256-Wod5tUaV+W4bSnoUndjG2GNDPqZjJ83kMRzn/XtXOR8=";
  };

  build-system = [ flit-core ];

  dependencies = [
    cachelib
    flask
  ];

  nativeCheckInputs = [
    asgiref
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # ignore flaky test
    "test_cache_timeout_dynamic"
    "test_cached_view_class"
  ];

  meta = {
    description = "Caching extension for Flask";
    homepage = "https://github.com/pallets-eco/flask-caching";
    changelog = "https://github.com/pallets-eco/flask-caching/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
