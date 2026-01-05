{
  lib,
  stdenv,
  aiofiles,
  aioquic,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  gunicorn,
  html5tagger,
  httptools,
  multidict,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  sanic-ext,
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
  version = "25.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic";
    tag = "v${version}";
    hash = "sha256-tucLXWYPpALQrPYf+aiovKHYf2iouu6jezvNdukEu9w=";
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
    ext = [ sanic-ext ];
    http3 = [ aioquic ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    gunicorn
    pytest-asyncio
    pytestCheckHook
    sanic-testing
    uvicorn
  ]
  ++ optional-dependencies.http3;

  preCheck = ''
    # Some tests depends on sanic on PATH
    PATH="$out/bin:$PATH"
    PYTHONPATH=$PWD:$PYTHONPATH

    # needed for relative paths for some packages
    cd tests
  ''
  # Work around "OSError: AF_UNIX path too long"
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace worker/test_socket.py \
      --replace-fail '"./test.sock"' '"/tmp/test.sock"'
  '';

  disabledTests = [
    # EOFError: Ran out of input
    "test_server_run_with_repl"
    # InvalidStatusCode: server rejected WebSocket connection: HTTP 400
    "test_websocket_route_with_subprotocols"
    # nic.exceptions.SanicException: Cannot setup Sanic Simple Server without a path to a directory
    "test_load_app_simple"
    # ModuleNotFoundError: No module named '/build/source/tests/tests/static'
    "test_input_is_dir"
    # Racy, e.g. Address already in use
    "test_logger_vhosts"
    # Event loop is closed
    "test_asyncio_server_no_start_serving"
    "test_asyncio_server_start_serving"
    "test_create_asyncio_server"
    "test_create_server_main_convenience"
    "test_create_server_main"
    "test_create_server_no_startup"
    "test_create_server_trigger_events"
    "test_multiple_uvloop_configs_display_warning"
    "test_uvloop_cannot_never_called_with_create_server"
  ];

  disabledTestPaths = [
    # We are not interested in benchmarks
    "benchmark/"
    # We are also not interested in typing
    "typing/test_typing.py"
    # occasionally hangs
    "test_multiprocessing.py"
    # Failed: async def functions are not natively supported.
    "test_touchup.py"
  ];

  # Avoid usage of nixpkgs-review in darwin since tests will compete usage
  # for the same local port
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sanic" ];

  meta = with lib; {
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    changelog = "https://github.com/sanic-org/sanic/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ p0lyw0lf ];
    mainProgram = "sanic";
  };
}
