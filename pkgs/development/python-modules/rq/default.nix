{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  click,
  redis,

  # tests
  psutil,
  pytestCheckHook,
  redis-server,
  sentry-sdk,
}:

buildPythonPackage rec {
  pname = "rq";
  version = "1.16.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${version}";
    hash = "sha256-8uhCV4aJNbY273jOa9D5OlgEG1w3hXVncClKQTO9Pyk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    redis
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    sentry-sdk
  ];

  preCheck = ''
    PATH=$out/bin:$PATH
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${redis-server}/bin/redis-server >/dev/null 2>&1 &
    REDIS_PID=$!

    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${redis-server}/bin/redis-cli --scan || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
      echo waiting for redis to be ready
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

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # https://github.com/rq/rq/commit/fd261d5d8fc0fe604fa396ee6b9c9b7a7bb4142f
    "test_clean_large_registry"
  ];

  pythonImportsCheck = [ "rq" ];

  meta = with lib; {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
