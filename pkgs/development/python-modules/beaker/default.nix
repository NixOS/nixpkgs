{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  pylibmc,
  python-memcached,
  redis,
  pymongo,
  mock,
  webtest,
  sqlalchemy,
  pycrypto,
  cryptography,
  isPy27,
  pytestCheckHook,
  setuptools,
  funcsigs ? null,
  pycryptopp ? null,
}:

buildPythonPackage rec {
  pname = "beaker";
  version = "1.13.0";
  pyproject = true;

  # The pypy release do not contains the tests
  src = fetchFromGitHub {
    owner = "bbangert";
    repo = "beaker";
    tag = version;
    hash = "sha256-HzjhOPXElwKoJLrhGIbVn798tbX/kaS1EpQIX+vXCtE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlalchemy
    pycrypto
    cryptography
  ]
  ++ lib.optionals (isPy27) [
    funcsigs
    pycryptopp
  ];

  nativeCheckInputs = [
    glibcLocales
    python-memcached
    mock
    pylibmc
    pymongo
    redis
    webtest
    pytestCheckHook
  ];

  # Can not run memcached tests because it immediately tries to connect.
  # Disable external tests because they need to connect to a live database.
  disabledTestPaths = [
    "tests/test_memcached.py"
    "tests/test_managers/test_ext_*"
  ];

  meta = {
    description = "Session and Caching library with WSGI Middleware";
    homepage = "https://github.com/bbangert/beaker";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    knownVulnerabilities = [ "CVE-2013-7489" ];
  };
}
