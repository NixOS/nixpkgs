{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  flask,
  cachelib,
  msgspec,

  # tests
  boto3,
  flask-sqlalchemy,
  memcachedTestHook,
  pytestCheckHook,
  redis,
  redisTestHook,
  pymongo,
  pymemcache,
  python-memcached,
}:

buildPythonPackage rec {
  pname = "flask-session";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-session";
    tag = version;
    hash = "sha256-QLtsM0MFgZbuLJPLc5/mUwyYc3bYxildNKNxOF8Z/3Y=";
  };

  build-system = [ flit-core ];

  dependencies = [
    cachelib
    flask
    msgspec
  ];

  nativeCheckInputs = [
    flask-sqlalchemy
    memcachedTestHook
    pytestCheckHook
    redis
    redisTestHook
    pymongo
    pymemcache
    python-memcached
    boto3
  ];

  disabledTests = [
    # unfree
    "test_mongo_default"
  ];

  disabledTestPaths = [ "tests/test_dynamodb.py" ];

  pythonImportsCheck = [ "flask_session" ];

  __darwinAllowLocalNetworking = true;

  # Hang indefinitely
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

  meta = {
    description = "Flask extension that adds support for server-side sessions";
    homepage = "https://github.com/pallets-eco/flask-session";
    changelog = "https://github.com/pallets-eco/flask-session/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
