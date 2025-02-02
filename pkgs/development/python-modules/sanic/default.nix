{
  lib,
  stdenv,
  aiofiles,
  aioquic,
  beautifulsoup4,
  buildPythonPackage,
  doCheck ? !stdenv.hostPlatform.isDarwin, # on Darwin, tests fail but pkg still works
  fetchFromGitHub,
  gunicorn,
  html5tagger,
  httptools,
  multidict,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  sanic-routing,
  sanic-testing,
  setuptools,
  tracerite,
  typing-extensions,
  ujson,
  uvicorn,
  uvloop,
  websockets,
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "24.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic";
    rev = "refs/tags/v${version}";
    hash = "sha256-AviYqdr+r5ya4mFJKGUatBsaMMmCQGqE3YtDJwTuaY0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    httptools
    html5tagger
    multidict
    sanic-routing
    tracerite
    typing-extensions
    ujson
    uvloop
    websockets
  ];

  optional-dependencies = {
    ext = [
      # TODO: sanic-ext
    ];
    http3 = [ aioquic ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    gunicorn
    pytest-asyncio
    pytestCheckHook
    sanic-testing
    uvicorn
  ] ++ optional-dependencies.http3;

  inherit doCheck;

  preCheck =
    ''
      # Some tests depends on sanic on PATH
      PATH="$out/bin:$PATH"
      PYTHONPATH=$PWD:$PYTHONPATH

      # needed for relative paths for some packages
      cd tests
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # OSError: [Errno 24] Too many open files
      ulimit -n 1024
    '';

  # uvloop usage is buggy
  #SANIC_NO_UVLOOP = true;

  pytestFlagsArray = [
    "--asyncio-mode=auto"
    "-vvv"
  ];

  disabledTests =
    [
      # Require networking
      "test_full_message"
      # Server mode mismatch (debug vs production)
      "test_num_workers"
      # Racy tests
      "test_custom_cert_loader"
      "test_keep_alive_client_timeout"
      "test_keep_alive_server_timeout"
      "test_logger_vhosts"
      "test_ssl_in_multiprocess_mode"
      "test_zero_downtime"
      # sanic.exceptions.SanicException: Cannot setup Sanic Simple Server without a path to a directory
      "test_load_app_simple"
      # Tests create defunct Python processes
      "test_reloader_live"
      "test_reloader_live_with_dir"
      "test_reload_listeners"
      # Tests crash the Python interpreter
      "test_host_port_localhost"
      "test_host_port"
      "test_server_run"
      # NoneType object is not subscriptable
      "test_serve_app_implicit"
      # AssertionError: assert [] == ['Restarting a process', 'Begin restart termination', 'Starting a process']
      "test_default_reload_shutdown_order"
      # App not found.
      "test_input_is_dir"
      # HTTP 500 with Websocket subprotocols
      "test_websocket_route_with_subprotocols"
      # Socket closes early
      "test_no_exceptions_when_cancel_pending_request"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # AttributeError: 'has_calls' is not a valid assertion. Use a spec for the mock if 'has_calls' is meant to be an attribute.
      "test_ws_frame_put_message_into_queue"
    ];

  disabledTestPaths = [
    # We are not interested in benchmarks
    "benchmark/"
    # We are also not interested in typing
    "typing/test_typing.py"
    # unable to create async loop
    "test_app.py"
    "test_asgi.py"
    # occasionally hangs
    "test_multiprocessing.py"
  ];

  # Avoid usage of nixpkgs-review in darwin since tests will compete usage
  # for the same local port
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sanic" ];

  meta = with lib; {
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    changelog = "https://github.com/sanic-org/sanic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "sanic";
  };
}
