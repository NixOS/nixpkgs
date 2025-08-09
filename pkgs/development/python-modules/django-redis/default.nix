{
  lib,
  fetchFromGitHub,
  pythonOlder,
  buildPythonPackage,
  setuptools,

  # propagated
  django,
  lz4,
  msgpack,
  pyzstd,
  redis,

  # testing
  pytest-cov-stub,
  pytest-django,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "django-redis";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-redis";
    tag = version;
    hash = "sha256-QfiyeeDQSRp/TkOun/HAQaPbIUY9yKPoOOEhKBX9Tec=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    lz4
    msgpack
    pyzstd
    redis
  ];

  optional-dependencies = {
    hiredis = [ redis ] ++ redis.optional-dependencies.hiredis;
  };

  pythonImportsCheck = [ "django_redis" ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings.sqlite
  '';

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-django
    pytest-mock
    pytest-xdist
    pytestCheckHook
    redisTestHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # https://github.com/jazzband/django-redis/issues/777
  dontUsePytestXdist = true;

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # AttributeError: <asgiref.local._CVar object at 0x7ffff57ed950> object has no attribute 'default'
    "test_delete_pattern_with_settings_default_scan_count"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Full featured redis cache backend for Django";
    homepage = "https://github.com/jazzband/django-redis";
    changelog = "https://github.com/jazzband/django-redis/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
