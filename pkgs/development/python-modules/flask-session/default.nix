{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  flask,
  cachelib,
  msgspec,

  # checks
  boto3,
  flask-sqlalchemy,
  pytestCheckHook,
  redis,
  pymongo,
  pymemcache,
  python-memcached,
  pkgs,
}:

buildPythonPackage rec {
  pname = "flask-session";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-session";
    rev = "refs/tags/${version}";
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
    pytestCheckHook
    redis
    pymongo
    pymemcache
    python-memcached
    boto3
  ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    ${pkgs.memcached}/bin/memcached &
  '';

  postCheck = ''
    kill %%
    kill %%
  '';

  disabledTests = [ "test_mongo_default" ]; # unfree

  disabledTestPaths = [ "tests/test_dynamodb.py" ];

  pythonImportsCheck = [ "flask_session" ];

  meta = with lib; {
    description = "Flask extension that adds support for server-side sessions";
    homepage = "https://github.com/pallets-eco/flask-session";
    changelog = "https://github.com/pallets-eco/flask-session/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
