{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy3k
, decorator
, http-parser
, python_magic
, urllib3
, pytestCheckHook
, pytest-mock
, aiohttp
, gevent
, redis
, requests
, sure
, pook
}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.9.44";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1e0d8ce14b3517c6d62170b8d7026b22d6ff6f639a8213f53d60e631750c6b8";
  };

  propagatedBuildInputs = [
    decorator
    http-parser
    python_magic
    urllib3
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    aiohttp
    gevent
    redis
    requests
    sure
    pook
  ];

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
  ];

  pythonImportsCheck = [ "mocket" ];

  meta = with lib; {
    description = "A socket mock framework - for all kinds of socket animals, web-clients included";
    homepage = "https://github.com/mindflayer/python-mocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
