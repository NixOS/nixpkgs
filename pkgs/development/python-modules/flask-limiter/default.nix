{
  lib,
  asgiref,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  hatchling,
  hatch-vcs,
  hiro,
  limits,
  ordered-set,
  pymemcache,
  pymongo,
  pytest-check,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  redis,
  rich,
}:

buildPythonPackage rec {
  pname = "flask-limiter";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "flask-limiter";
    tag = version;
    hash = "sha256-lrq4WCc2gxm039nXW6tiDt7laJFEICO0x9jw71UUwaI=";
  };

  postPatch = ''
    # flask-restful is unmaintained and breaks regularly, don't depend on it
    substituteInPlace tests/test_views.py \
      --replace-fail "import flask_restful" ""
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    flask
    limits
    ordered-set
  ];

  optional-dependencies = {
    cli = [ rich ];
    redis = limits.optional-dependencies.redis;
    memcached = limits.optional-dependencies.memcached;
    mongodb = limits.optional-dependencies.mongodb;
  };

  nativeCheckInputs = [
    asgiref
    pytest-check
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    hiro
    redis
    pymemcache
    pymongo
  ]
  ++ optional-dependencies.cli;

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

  meta = {
    description = "Rate limiting for flask applications";
    homepage = "https://flask-limiter.readthedocs.org/";
    changelog = "https://github.com/alisaifee/flask-limiter/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
