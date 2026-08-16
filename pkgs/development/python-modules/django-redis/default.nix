{
  lib,
  fetchFromGitHub,
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
  pytest8_3CheckHook,
  redisTestHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-redis";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-redis";
    tag = finalAttrs.version;
    hash = "sha256-4YNhNsa0J1tTtaeJTHnwT8WwYs6QQuxnjVl1mAYNePI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    redis
  ];

  optional-dependencies = {
    hiredis = [ redis ] ++ redis.optional-dependencies.hiredis;
    lz4 = [ lz4 ];
    msgpack = [ msgpack ];
    pyzstd = [ pyzstd ];
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
    pytest8_3CheckHook
    redisTestHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # https://github.com/jazzband/django-redis/issues/777
  dontUsePytestXdist = true;

  disabledTests = [
    # AttributeError: <asgiref.local._CVar object at 0x7ffff57ed950> object has no attribute 'default'
    "test_delete_pattern_with_settings_default_scan_count"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Full featured redis cache backend for Django";
    homepage = "https://github.com/jazzband/django-redis";
    changelog = "https://github.com/jazzband/django-redis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
