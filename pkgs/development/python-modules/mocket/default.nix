{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  stdenv,

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
  pytestCheckHook,
  redis,
  redis-server,
  requests,
  sure,

}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.12.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6yWo7SBlVldK+AxUBnQOXjQBxz9HbIC+Ch977xiZxek=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    decorator
    httptools
    python-magic
    urllib3
  ];

  passthru.optional-dependencies = {
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
      pytestCheckHook
      redis
      requests
      sure
    ]
    ++ lib.optionals (pythonOlder "3.12") [ aiohttp ]
    ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = lib.optionalString stdenv.isLinux ''
    ${redis-server}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = lib.optionalString stdenv.isLinux ''
    kill $REDIS_PID
  '';

  # Skip http tests, they require network access
  env.SKIP_TRUE_HTTP = true;

  _darwinAllowLocalNetworking = true;

  disabledTests = [
    # tests that require network access (like DNS lookups)
    "test_truesendall_with_dump_from_recording"
    "test_asyncio_record_replay"
    "test_gethostbyname"
    # httpx read failure
    "test_no_dangling_fds"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [ "tests/main/test_redis.py" ];

  pythonImportsCheck = [ "mocket" ];

  meta = with lib; {
    changelog = "https://github.com/mindflayer/python-mocket/releases/tag/${version}";
    description = "A socket mock framework for all kinds of sockets including web-clients";
    homepage = "https://github.com/mindflayer/python-mocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
