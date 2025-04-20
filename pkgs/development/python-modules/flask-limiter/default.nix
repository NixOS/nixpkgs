{
  lib,
  asgiref,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "3.12";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "flask-limiter";
    tag = version;
    hash = "sha256-3GFbLQExd4c3Cyr7UDX/zOAfedOluXMwCbBhOgoKfn0=";
  };

  patches = [
    # permit use of rich < 15 -- remove when updating past 3.12
    (fetchpatch {
      url = "https://github.com/alisaifee/flask-limiter/commit/008a5c89f249e18e5375f16d79efc3ac518e9bcc.patch";
      hash = "sha256-dvTPVnuPs7xCRfUBBA1bgeWGuevFUZ+Kgl9MBHdgfKU=";
    })
  ];

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
    changelog = "https://github.com/alisaifee/flask-limiter/blob/${src.tag}/HISTORY.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
