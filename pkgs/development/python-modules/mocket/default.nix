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
  version = "3.9.40";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "061w3zqf4ir7hfj0vzl58lg8szsik1fxv126s32x03nk1sd39r6v";
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
