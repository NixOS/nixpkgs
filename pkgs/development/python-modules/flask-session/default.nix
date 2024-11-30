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
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${pkgs.redis}/bin/redis-server >/dev/null 2>&1 &
    REDIS_PID=$!
    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${pkgs.redis}/bin/redis-cli --scan || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
      echo "Waiting for redis to be ready"
      sleep 1
      RETRY_COUNT=$((RETRY_COUNT + 1))
    done
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
      echo "Redis failed to start after $MAX_RETRIES retries"
      exit 1
    fi

    ${pkgs.memcached}/bin/memcached >/dev/null 2>&1 &
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
