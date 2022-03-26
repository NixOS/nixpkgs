{ lib
, stdenv
, aiofiles
, beautifulsoup4
, buildPythonPackage
, doCheck ? true
, fetchFromGitHub
, gunicorn
, httptools
, multidict
, pytest-asyncio
, pytest-benchmark
, pytest-sugar
, pytestCheckHook
, pythonOlder
, pythonAtLeast
, sanic-routing
, sanic-testing
, ujson
, uvicorn
, uvloop
, websockets
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "21.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7" ||
    pythonAtLeast "3.10";  # see GHSA-7p79-6x2v-5h88

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jyl23q7b7fyqzan97qflkqcvmfpzbxbzv0qgygxasrzh80zx67g";
  };

  postPatch = ''
    # Loosen dependency requirements.
    substituteInPlace setup.py \
      --replace '"pytest==6.2.5"' '"pytest"' \
      --replace '"gunicorn==20.0.4"' '"gunicorn"' \
      --replace '"pytest-sanic",' "" \
    # Patch a request headers test to allow brotli encoding
    # (we build httpx with brotli support, upstream doesn't).
    substituteInPlace tests/test_headers.py \
      --replace "deflate\r\n" "deflate, br\r\n"
  '';

  propagatedBuildInputs = [
    aiofiles
    httptools
    multidict
    sanic-routing
    ujson
    uvloop
    websockets
  ];

  checkInputs = [
    beautifulsoup4
    gunicorn
    pytest-asyncio
    pytest-benchmark
    pytest-sugar
    pytestCheckHook
    sanic-testing
    uvicorn
  ];

  inherit doCheck;

  preCheck = ''
    # Some tests depends on sanic on PATH
    PATH="$out/bin:$PATH"
    PYTHONPATH=$PWD:$PYTHONPATH

    # needed for relative paths for some packages
    cd tests
  '';

  # uvloop usage is buggy
  #SANIC_NO_UVLOOP = true;

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  disabledTests = [
    # Lack of uvloop setup through fixtures
    "test_create_asyncio_server"
    "test_listeners_triggered_async"
    "test_tls_options"
    # Tests are flaky
    "test_keep_alive_client_timeout"
    "test_check_timeouts_request_timeout"
    "test_check_timeouts_response_timeout"
    "test_reloader_live"
    "test_zero_downtime"
    # Not working from 21.9.1
    "test_create_server_main"
    "test_create_server_main_convenience"
    "test_debug"
    "test_auto_reload"
    "test_no_exceptions_when_cancel_pending_request"
    "test_ipv6_address_is_not_wrapped"
    # Failure of the redirect tests seems to be related to httpx>0.20.0
    "test_redirect"
    "test_chained_redirect"
    "test_unix_connection"
    # These appear to be very sensitive to output of commands
    "test_access_logs"
    "test_auto_reload"
    "test_host_port"
    "test_no_exceptions_when_cancel_pending_request"
    "test_num_workers"
    "test_server_run"
    "test_version"
  ];

  disabledTestPaths = [
    # unable to create async loop
    "test_app.py"
    "test_asgi.py"
    # occasionally hangs
    "test_multiprocessing.py"
  ];

  # avoid usage of nixpkgs-review in darwin since tests will compete usage
  # for the same local port
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "sanic"
  ];

  meta = with lib; {
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc AluisioASG ];
  };
}
