{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jsonpath-ng,
  lupa,
  poetry-core,
  pyprobables,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  redis,
  redis-server,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.26.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-eBWdrN6QfrZaavKGuVMaU0s+k0VpsBCIaIzuxC7HyYE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    redis
    sortedcontainers
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  optional-dependencies = {
    lua = [ lupa ];
    json = [ jsonpath-ng ];
    bf = [ pyprobables ];
    cf = [ pyprobables ];
    probabilistic = [ pyprobables ];
  };

  pythonImportsCheck = [ "fakeredis" ];

  pytestFlagsArray = [ "-m 'not slow'" ];

  preCheck = ''
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${redis-server}/bin/redis-server --port 6390 >/dev/null 2>&1 &
    REDIS_PID=$!
    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${redis-server}/bin/redis-cli --scan -p 6390 || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
      echo "Waiting for redis to be ready"
      sleep 1
      RETRY_COUNT=$((RETRY_COUNT + 1))
    done
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
      echo "Redis failed to start after $MAX_RETRIES retries"
      exit 1
    fi
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  disabledTests = [
    # AssertionError
    "test_command"
  ];

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
