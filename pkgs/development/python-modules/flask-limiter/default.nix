{ lib
, asgiref
, buildPythonPackage
, fetchFromGitHub
, flask
, hiro
, limits
, ordered-set
, pymemcache
, pymongo
, pytest-mock
, pytestCheckHook
, pythonOlder
, redis
, rich
, typing-extensions
}:

buildPythonPackage rec {
  pname = "flask-limiter";
  version = "3.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "flask-limiter";
    rev = "refs/tags/${version}";
    hash = "sha256-UtmMd180bwFm426YevARq6r7DL182dI7dGAUPFKLWuM=";
  };

  postPatch = ''
    sed -i "/--cov/d" pytest.ini

    # flask-restful is unmaintained and breaks regularly, don't depend on it
    sed -i "/import flask_restful/d" tests/test_views.py
  '';

  propagatedBuildInputs = [
    flask
    limits
    ordered-set
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    asgiref
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

  pythonImportsCheck = [
    "flask_limiter"
  ];

  meta = with lib; {
    description = "Rate limiting for flask applications";
    homepage = "https://flask-limiter.readthedocs.org/";
    changelog = "https://github.com/alisaifee/flask-limiter/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
