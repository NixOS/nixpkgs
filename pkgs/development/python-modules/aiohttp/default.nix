{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, chardet
, multidict
, async-timeout
, yarl
, idna-ssl
, typing-extensions
, pytestrunner
, pytestCheckHook
, gunicorn
, async_generator
, pytest_xdist
, pytestcov
, pytest-mock
, trustme
, brotlipy
, freezegun
, isPy38
, re-assert
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.7.3";
  # https://github.com/aio-libs/aiohttp/issues/4525 python3.8 failures
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c1a81af067e72261c9cbe33ea792893e83bc6aa987bfbd6fdc1e5e7b22777c4";
  };

  checkInputs = [
    pytestrunner pytestCheckHook gunicorn async_generator pytest_xdist
    pytest-mock pytestcov trustme brotlipy freezegun
    re-assert
  ];

  propagatedBuildInputs = [
    attrs
    chardet
    multidict
    async-timeout
    typing-extensions
    yarl
  ] ++ lib.optionals (pythonOlder "3.7") [
    idna-ssl
  ];

  disabledTests = [
    # disable tests which attempt to do loopback connections
    "get_valid_log_format_exc"
    "test_access_logger_atoms"
    "aiohttp_request_coroutine"
    "server_close_keepalive_connection"
    "connector"
    "client_disconnect"
    "handle_keepalive_on_closed_connection"
    "proxy_https_bad_response"
    "partially_applied_handler"
    "middleware"
    "test_mark_formdata_as_processed"
    # no longer compatible with pytest>=6
    "aiohttp_plugin_async_fixture"
  ] ++ lib.optionals stdenv.is32bit [
    "test_cookiejar"
  ] ++ lib.optionals isPy38 [
    # Python 3.8  https://github.com/aio-libs/aiohttp/issues/4525
    "test_read_boundary_with_incomplete_chunk"
    "test_read_incomplete_chunk"
    "test_request_tracing_exception"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_addresses"  # https://github.com/aio-libs/aiohttp/issues/3572
    "test_close"
  ];

  # aiohttp in current folder shadows installed version
  # Probably because we run `python -m pytest` instead of `pytest` in the hook.
  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp";
    maintainers = with maintainers; [ dotlambda ];
  };
}
