{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  cachelib,
  flask,
  pytz,

  # tests
  elasticsearch,
  flask-sqlalchemy,
  peewee,
  pymemcache,
  pymongo,
  pytestCheckHook,
  redis,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "flask-session2";
  version = "1.3.1";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "christopherpickering";
    repo = "flask-session2";
    tag = "v${version}";
    hash = "sha256-kxUuEirUG/jZlygKyQy2Sm7hmB331K2q8vBmcIbp7/s=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cachelib
    flask
    pytz
  ];

  pythonRelaxDeps = [
    "cachelib"
    "flask"
    "pytz"
  ];

  nativeCheckInputs = [
    elasticsearch
    flask-sqlalchemy
    peewee
    pymemcache
    pymongo
    pytestCheckHook
    redis
    redisTestHook
  ];

  disabledTests = [
    "test_elasticsearch_session"
    "test_flasksqlalchemy_session"
    "test_flasksqlalchemy_session_with_signer"
    "test_memcached_session"
    "test_mongodb_session"
    "test_session_use_signer"
  ];

  pythonImportsCheck = [ "flask_session" ];

  meta = {
    description = "Flask extension that adds support for server-side sessions";
    homepage = "https://github.com/christopherpickering/flask-session2";
    changelog = "https://github.com/christopherpickering/flask-session2/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
