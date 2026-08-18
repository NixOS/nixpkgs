{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest-xdist,
  pytestCheckHook,
  mako,
  decorator,
  stevedore,
}:

buildPythonPackage rec {
  pname = "dogpile-cache";
  version = "1.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "dogpile_cache";
    inherit version;
    hash = "sha256-hJxVc8mjjxVc1BcxA8cCtjft4DYcEuhkh2h30M0SXuw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    stevedore
  ];

  nativeCheckInputs = [
    mako
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # flaky
    "tests/cache/test_dbm_backend.py"
    # timing sensitive
    "tests/test_lock.py::ConcurrencyTest"
  ];

  meta = {
    description = "Caching front-end based on the Dogpile lock";
    homepage = "https://github.com/sqlalchemy/dogpile.cache";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
