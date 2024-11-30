{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  decorator,
  httptools,
  python-magic,
  urllib3,

  # optional-dependencies
  xxhash,
  pook,

  # tests
  aiohttp,
  asgiref,
  fastapi,
  gevent,
  httpx,
  psutil,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  redis,
  redis-server,
  requests,
  sure,

}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GFzIDSE+09L4RC5w4h3fqgq9lkyOVjq5JN++ZNbHWc8=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    decorator
    httptools
    python-magic
    urllib3
  ];

  optional-dependencies = {
    pook = [ pook ];
    speedups = [ xxhash ];
  };

  nativeCheckInputs =
    [
      asgiref
      fastapi
      gevent
      httpx
      psutil
      pytest-asyncio
      pytest-cov-stub
      pytestCheckHook
      redis
      requests
      sure
    ]
    ++ lib.optionals (pythonOlder "3.12") [ aiohttp ]
    ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${redis-server}/bin/redis-server >/dev/null 2>&1 &
    REDIS_PID=$!
    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${redis-server}/bin/redis-cli --scan || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
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

  # Skip http tests, they require network access
  env.SKIP_TRUE_HTTP = true;

  _darwinAllowLocalNetworking = true;

  disabledTests = [
    # tests that require network access (like DNS lookups)
    "test_truesendall_with_dump_from_recording"
    "test_aiohttp"
    "test_asyncio_record_replay"
    "test_gethostbyname"
    # httpx read failure
    "test_no_dangling_fds"
  ];

  pythonImportsCheck = [ "mocket" ];

  meta = with lib; {
    changelog = "https://github.com/mindflayer/python-mocket/releases/tag/${version}";
    description = "Socket mock framework for all kinds of sockets including web-clients";
    homepage = "https://github.com/mindflayer/python-mocket";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
