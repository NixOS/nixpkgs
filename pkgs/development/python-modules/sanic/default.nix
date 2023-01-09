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
, aioquic
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "22.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Vj780rP5rJ+YsMWlb3BR9LTKT/nTt0C2H3J0X9sysj8=";
  };

  propagatedBuildInputs = [
    aiofiles
    aioquic
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
  '' + lib.optionalString stdenv.isDarwin  ''
    # OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  # uvloop usage is buggy
  #SANIC_NO_UVLOOP = true;

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  disabledTests = [
    # Require networking
    "test_full_message"
    # Fails to parse cmdline arguments
    "test_dev"
    "test_auto_reload"
    "test_host_port_ipv6_loopback"
    "test_num_workers"
    "test_debug"
    "test_access_logs"
    "test_noisy_exceptions"
    # OSError: foo
    "test_bad_headers"
    "test_create_server_trigger_events"
    "test_json_body_requests"
    "test_missing_startup_raises_exception"
    "test_no_body_requests"
    "test_oserror_warning"
    "test_running_multiple_offset_warning"
    "test_streaming_body_requests"
    "test_trigger_before_events_create_server"
    "test_keep_alive_connection_context"
    # Racy tests
    "test_keep_alive_client_timeout"
    "test_keep_alive_server_timeout"
    "test_zero_downtime"
    # TLS tests
    "test_missing_sni"
    "test_no_matching_cert"
    "test_wildcards"
    # They thtow execptions
    "test_load_app_simple"
    "worker/test_loader.py"
    # broke with ujson 5.4 upgrade
    # https://github.com/sanic-org/sanic/pull/2504
    "test_json_response_json"
  ];

  disabledTestPaths = [
    # We are not interested in benchmarks
    "benchmark/"
    # unable to create async loop
    "test_app.py"
    "test_asgi.py"
    # occasionally hangs
    "test_multiprocessing.py"
  ];

  # avoid usage of nixpkgs-review in darwin since tests will compete usage
  # for the same local port
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sanic" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    changelog = "https://github.com/sanic-org/sanic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc AluisioASG ];
  };
}
