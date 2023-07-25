{ lib
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, buildPythonPackage

# propagated
, django
, hiredis
, lz4
, msgpack
, redis

# testing
, pkgs
, pytest-django
, pytest-mock
, pytestCheckHook
}:

let
  pname = "django-redis";
  version = "5.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-redis";
    rev = version;
    hash = "sha256-e8wCgfxBT+WKFY4H83CTMirTpQym3QAoeWnXbRCDO90=";
  };

  postPatch = ''
    sed -i '/-cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    django
    hiredis
    lz4
    msgpack
    redis
  ];

  pythonImportsCheck = [
    "django_redis"
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings.sqlite";

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  nativeCheckInputs = [
    pytest-django
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals (pythonAtLeast "3.11") [
    # DeprecationWarning: 'cgi' is deprecated and slated for removal in Python 3.13
    "-W" "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # ModuleNotFoundError: No module named 'test_cache_options'
    "test_custom_key_function"
    # ModuleNotFoundError: No module named 'test_client'
    "test_delete_pattern_calls_get_client_given_no_client"
    "test_delete_pattern_calls_make_pattern"
    "test_delete_pattern_calls_scan_iter_with_count_if_itersize_given"
    "test_delete_pattern_calls_scan_iter_with_count_if_itersize_given"
    "test_delete_pattern_calls_scan_iter"
    "test_delete_pattern_calls_delete_for_given_keys"
  ];

  meta = with lib; {
    description = "Full featured redis cache backend for Django";
    homepage = "https://github.com/jazzband/django-redis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
