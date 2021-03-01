{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27
, decorator
, http-parser
, importlib-metadata
, python
, python_magic
, six
, urllib3
, pytestCheckHook
, pytest-mock
, aiohttp
, gevent
, redis
, requests
, sure
}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.9.39";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mbcgfy1vfwwzn54vkq8xmfzdyc28brfpqk4d55r3a6abwwsn6a4";
  };

  propagatedBuildInputs = [
    decorator
    http-parser
    python_magic
    urllib3
    six
  ] ++ lib.optionals (isPy27) [ six ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    aiohttp
    gevent
    redis
    requests
    sure
  ];

  pytestFlagsArray = [
    "--ignore=tests/main/test_pook.py" # pook is not packaged
    "--ignore=tests/main/test_redis.py" # requires a live redis instance
  ] ++ lib.optionals (pythonOlder "3.8") [
    # uses IsolatedAsyncioTestCase which is only available >= 3.8
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
  ];

  pythonImportsCheck = [ "mocket" ];

  meta = with lib; {
    description = "A socket mock framework - for all kinds of socket animals, web-clients included";
    homepage = "https://github.com/mindflayer/python-mocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
