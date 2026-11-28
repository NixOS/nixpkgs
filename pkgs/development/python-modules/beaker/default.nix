{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  python-memcached,
  redis,
  pymongo,
  webtest,
  sqlalchemy,
  cryptography,
  pycryptodome,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "beaker";
  version = "1.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbangert";
    repo = "beaker";
    tag = finalAttrs.version;
    hash = "sha256-LvpsknCAXVoRFCy1jlrlqeAPpHhEbtCXuQuBf+vBJDs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sqlalchemy
    cryptography
  ];

  optional-dependencies = {
    cryptography = [ cryptography ];
    pycryptodome = [ pycryptodome ];
  };

  # Tests are failing on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    glibcLocales
    python-memcached
    pymongo
    redis
    webtest
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Can not run memcached tests because it immediately tries to connect.
  # Disable external tests because they need to connect to a live database.
  disabledTestPaths = [
    "tests/test_memcached.py"
    "tests/test_managers/test_ext_*"
  ];

  pythonImportsCheck = [ "beaker" ];

  meta = {
    description = "Session and Caching library with WSGI Middleware";
    homepage = "https://github.com/bbangert/beaker";
    changelog = "https://github.com/bbangert/beaker/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    knownVulnerabilities = [ "CVE-2013-7489" ];
  };
})
