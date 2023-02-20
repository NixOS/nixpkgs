{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy3k
, decorator
, http-parser
, python-magic
, urllib3
, pytestCheckHook
, pytest-mock
, aiohttp
, fastapi
, gevent
, httpx
, redis
, requests
, sure
, pook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.10.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fAVw5WvpJOITQWqA8Y6Xi7QbaunZ1WGXxAuUMXbh+Aw=";
  };

  propagatedBuildInputs = [
    decorator
    http-parser
    python-magic
    urllib3
  ];

  passthru.optional-dependencies = {
    pook = [
      pook
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    aiohttp
    fastapi
    gevent
    httpx
    redis
    requests
    sure
  ] ++ passthru.optional-dependencies.pook;

  # skip http tests
  SKIP_TRUE_HTTP = true;

  pytestFlagsArray = [
    # Requires a live Redis instance
    "--ignore=tests/main/test_redis.py"
  ] ++ lib.optionals (pythonOlder "3.8") [
    # Uses IsolatedAsyncioTestCase which is only available >= 3.8
    "--ignore=tests/tests38/test_http_aiohttp.py"
  ];

  disabledTests = [
    # tests that require network access (like DNS lookups)
    "test_truesendall"
    "test_truesendall_with_chunk_recording"
    "test_truesendall_with_gzip_recording"
    "test_truesendall_with_recording"
    "test_wrongpath_truesendall"
    "test_truesendall_with_dump_from_recording"
    "test_truesendall_with_recording_https"
    "test_truesendall_after_mocket_session"
    "test_real_request_session"
    "test_asyncio_record_replay"
    "test_gethostbyname"
  ];

  pythonImportsCheck = [ "mocket" ];

  meta = with lib; {
    description = "A socket mock framework for all kinds of sockets including web-clients";
    homepage = "https://github.com/mindflayer/python-mocket";
    changelog = "https://github.com/mindflayer/python-mocket/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
