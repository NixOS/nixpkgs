{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-restful
, hiro
, limits
, mock
, pymemcache
, pytestCheckHook
, redis
}:

buildPythonPackage rec {
  pname = "Flask-Limiter";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "flask-limiter";
    rev = version;
    sha256 = "1k1b4b3s1acphqnar0y5g747bh1y7w35gcl5g819idq2a5vqnass";
  };

  propagatedBuildInputs = [ flask limits ];

  checkInputs = [
    pytestCheckHook
    hiro
    mock
    redis
    flask-restful
    pymemcache
  ];

  postPatch = ''
    sed -i "/--cov/d" pytest.ini
  '';

  # Some tests requires a local Redis instance
  disabledTests = [
    "test_fallback_to_memory"
    "test_reset_unsupported"
    "test_constructor_arguments_over_config"
    "test_fallback_to_memory_config"
    "test_fallback_to_memory_backoff_check"
    "test_fallback_to_memory_with_global_override"
    "test_custom_key_prefix"
    "test_redis_request_slower_than_fixed_window"
    "test_redis_request_slower_than_moving_window"
    "test_custom_key_prefix_with_headers"
  ];

  pythonImportsCheck = [ "flask_limiter" ];

  meta = with lib; {
    description = "Rate limiting for flask applications";
    homepage = "https://flask-limiter.readthedocs.org/";
    license = licenses.mit;
  };
}
