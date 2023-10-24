{ lib
, aiohttp
, asgiref
, buildPythonPackage
, decorator
, fastapi
, fetchPypi
, gevent
, httptools
, httpx
, isPy3k
, pook
, pytest-mock
, pytestCheckHook
, python-magic
, pythonOlder
, redis
, requests
, sure
, urllib3
}:

buildPythonPackage rec {
  pname = "mocket";
  version = "3.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sEPLUN9nod4AKYcoCNQZ4FBblUCLCPV1dFOrNC6xDWo=";
  };

  propagatedBuildInputs = [
    decorator
    httptools
    python-magic
    urllib3
  ];

  passthru.optional-dependencies = {
    pook = [
      pook
    ];
  };

  nativeCheckInputs = [
    aiohttp
    asgiref
    fastapi
    gevent
    httpx
    pytest-mock
    pytestCheckHook
    redis
    requests
    sure
  ] ++ passthru.optional-dependencies.pook;

  # Skip http tests
  SKIP_TRUE_HTTP = true;

  disabledTestPaths = [
    # Requires a live Redis instance
    "tests/main/test_redis.py"
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

  pythonImportsCheck = [
    "mocket"
  ];

  meta = with lib; {
    description = "A socket mock framework for all kinds of sockets including web-clients";
    homepage = "https://github.com/mindflayer/python-mocket";
    changelog = "https://github.com/mindflayer/python-mocket/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
