{
  lib,
  asgiref,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  hiro,
  limits,
  ordered-set,
  pymemcache,
  pymongo,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  redis,
  rich,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "flask-limiter";
  version = "3.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "flask-limiter";
    rev = "refs/tags/${version}";
    hash = "sha256-RkeG5XdanSp2syKrQgYUZ4r8D28Zt33/MsW0UxWxaU0=";
  };

  postPatch = ''
    # flask-restful is unmaintained and breaks regularly, don't depend on it
    substituteInPlace tests/test_views.py \
      --replace-fail "import flask_restful" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    flask
    limits
    ordered-set
    rich
    typing-extensions
  ];

  optional-dependencies = {
    redis = limits.optional-dependencies.redis;
    memcached = limits.optional-dependencies.memcached;
    mongodb = limits.optional-dependencies.mongodb;
  };

  nativeCheckInputs = [
    asgiref
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    hiro
    redis
    pymemcache
    pymongo
  ];

  disabledTests = [
    # flask-restful is unmaintained and breaks regularly
    "test_flask_restful_resource"

    # Requires running a docker instance
    "test_clear_limits"
    "test_constructor_arguments_over_config"
    "test_custom_key_prefix"
    "test_custom_key_prefix_with_headers"
    "test_fallback_to_memory_backoff_check"
    "test_fallback_to_memory_config"
    "test_fallback_to_memory_with_global_override"
    "test_redis_request_slower_than_fixed_window"
    "test_redis_request_slower_than_moving_window"
    "test_reset_unsupported"

    # Requires redis
    "test_fallback_to_memory"
  ];

  disabledTestPaths = [
    # requires running redis/memcached/mongodb
    "tests/test_storage.py"
  ];

  pythonImportsCheck = [ "flask_limiter" ];

  meta = with lib; {
    description = "Rate limiting for flask applications";
    homepage = "https://flask-limiter.readthedocs.org/";
    changelog = "https://github.com/alisaifee/flask-limiter/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
