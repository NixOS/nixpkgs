{
  lib,
  arrow,
  blessed,
  boto3,
  bson,
  buildPythonPackage,
  croniter,
  django,
  django-picklefield,
  django-redis,
  fetchFromGitHub,
  hiredis,
  uv-build,
  pytest-django,
  pytestCheckHook,
  redisTestHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "django-q2";
  version = "1.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-q2";
    repo = "django-q2";
    tag = "v${version}";
    hash = "sha256-GiheD09kKNhD2bhf/DTf7xTTQ9CSs1DbCiQ1bySpl+c=";
  };

  postPatch = ''
    sed -i 's/uv_build[<>=0-9.,]*[0-9]/uv_build/g' pyproject.toml
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    arrow
    bson # required for mongodb but undocumented
    django
    django-picklefield
  ];

  nativeCheckInputs = [
    blessed
    boto3
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
    # botocore.exceptions.NoRegionError: You must specify a region.
    "test_sqs"
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
    #  assert 0 == 1 where 0 = <django_q.cluster.Sentinel object at 0x7ffff3861e50>.reincarnations
    "django_q/tests/test_cluster.py::test_recycle"
    "django_q/tests/test_cluster.py::test_max_rss"
  ];

  pytestFlags = [ "-vv" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Multiprocessing distributed task queue for Django based on Django-Q";
    homepage = "https://github.com/django-q2/django-q2";
    changelog = "https://github.com/django-q2/django-q2/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
