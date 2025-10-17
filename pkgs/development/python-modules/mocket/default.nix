{
  lib,
  buildPythonPackage,
  stdenv,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  decorator,
  h11,
  puremagic,
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
  redisTestHook,
  requests,
  sure,

}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.14.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-68bjR5lf1sKxShM4p3Fm7ff8HvmTk2Fdz53CwfHI9Q8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    decorator
    h11
    puremagic
    urllib3
  ];

  optional-dependencies = {
    pook = [ pook ];
    speedups = [ xxhash ];
  };

  nativeCheckInputs = [
    aiohttp
    asgiref
    fastapi
    gevent
    httpx
    psutil
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    redis
    redisTestHook
    requests
    sure
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # Skip http tests, they require network access
  env.SKIP_TRUE_HTTP = true;

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # tests that require network access (like DNS lookups)
    "test_truesendall_with_dump_from_recording"
    "test_aiohttp"
    "test_asyncio_record_replay"
    "test_gethostbyname"
    # httpx read failure
    "test_no_dangling_fds"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails on darwin due to upstream bug: https://github.com/mindflayer/python-mocket/issues/287
    "test_httprettish_httpx_session"
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
