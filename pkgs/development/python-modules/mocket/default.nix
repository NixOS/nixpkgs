{
  lib,
  buildPythonPackage,
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
  version = "3.13.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gms2WOZowrwf6EQt94QLW3cxhUT1wVeplSd2sX6/8qI=";
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
