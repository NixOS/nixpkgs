{
  lib,
  arrow,
  blessed,
  bson,
  buildPythonPackage,
  croniter,
  django,
  django-picklefield,
  django-redis,
  fetchFromGitHub,
  hiredis,
  poetry-core,
  pytest-django,
  pytestCheckHook,
  redisTestHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "django-q2";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-q2";
    repo = "django-q2";
    tag = "v${version}";
    hash = "sha256-SmTiplQzmMiK6xBs1TDikHE1ChI2twqemaP/ID6kvc4=";
  };

  postPatch = ''
    substituteInPlace django_q/tests/settings.py \
      --replace-fail "HiredisParser" "_HiredisParser"
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    arrow
    bson # required for mongodb but undocumented
    django
    django-picklefield
  ];

  nativeCheckInputs = [
    blessed
    croniter
    django-redis
    hiredis
    pytest-django
    pytestCheckHook
    redisTestHook
  ];

  pythonImportsCheck = [ "django_q" ];

  env = {
    MONGO_HOST = "127.0.0.1";
    REDIS_HOST = "127.0.0.1";
  };

  disabledTests = [
    # requires a running mongodb
    "test_mongo"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails with an assertion
    "test_max_rss"
    "test_recycle"
    # cannot connect to redis
    "test_broker"
    "test_custom"
    "test_redis"
    "test_redis_connection"
  ];

  disabledTestPaths = [
    "django_q/tests/test_commands.py"
  ];

  pytestFlags = [ "-vv" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Multiprocessing distributed task queue for Django based on Django-Q";
    homepage = "https://github.com/django-q2/django-q2";
    changelog = "https://github.com/django-q2/django-q2/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
