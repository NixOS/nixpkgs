{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  mako,
  decorator,
  stdenv,
  stevedore,
  typing-extensions,
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
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mako
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: <dogpile.cache.api.NoValue object> != 'some value 1'
    "test_expire_override"
    # flaky
    "test_get_value_plus_created_long_create"
    "test_get_value_plus_created_registry_safe_cache_quick"
    "test_get_value_plus_created_registry_safe_cache_slow"
    "test_get_value_plus_created_registry_unsafe_cache"
    "test_quick"
    "test_return_while_in_progress"
    "test_slow"
  ];

  meta = {
    description = "Caching front-end based on the Dogpile lock";
    homepage = "https://github.com/sqlalchemy/dogpile.cache";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
