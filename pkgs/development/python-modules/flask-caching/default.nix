{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  cachelib,
  flask,
  asgiref,
  pytest-asyncio,
  pytest-xprocess,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-caching";
  version = "2.3.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "flask_caching";
    inherit version;
    hash = "sha256-1+TKZKM7Sf6zOfzdF+a6JfXgEWjPiF5TeQ6IX4Ok0s8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cachelib >= 0.9.0, < 0.10.0" "cachelib"
  '';

  propagatedBuildInputs = [
    cachelib
    flask
  ];

  nativeCheckInputs = [
    asgiref
    pytest-asyncio
    pytest-xprocess
    pytestCheckHook
  ];

  disabledTests =
    [
      # backend_cache relies on pytest-cache, which is a stale package from 2013
      "backend_cache"
      # optional backends
      "Redis"
      "Memcache"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # ignore flaky test
      "test_cache_timeout_dynamic"
      "test_cached_view_class"
    ];

  meta = with lib; {
    description = "Caching extension for Flask";
    homepage = "https://github.com/pallets-eco/flask-caching";
    changelog = "https://github.com/pallets-eco/flask-caching/blob/v${version}/CHANGES.rst";
    maintainers = [ ];
    license = licenses.bsd3;
  };
}
