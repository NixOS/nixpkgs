{ lib
, stdenv
<<<<<<< HEAD
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

# build-system
, setuptools
, wheel

# propagates
, aiofiles
, html5tagger
, httptools
, multidict
, sanic-routing
, tracerite
, typing-extensions
, ujson
, uvloop
, websockets

# optionals
, aioquic

# tests
, doCheck ? !stdenv.isDarwin # on Darwin, tests fail but pkg still works

, beautifulsoup4
, gunicorn
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, sanic-testing
, uvicorn
=======
, aiofiles
, beautifulsoup4
, buildPythonPackage
, doCheck ? !stdenv.isDarwin # on Darwin, tests fail but pkg still works
, fetchFromGitHub
, gunicorn
, httptools
, multidict
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonAtLeast
, sanic-routing
, sanic-testing
, setuptools
, ujson
, uvicorn
, uvloop
, websockets
, aioquic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sanic";
<<<<<<< HEAD
  version = "23.6.0";
=======
  version = "22.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Ffw92mlYNV+ikb6299uw24EI1XPpl3Ju2st1Yt/YHKw=";
  };

  patches = [
    # https://github.com/sanic-org/sanic/pull/2801
    (fetchpatch {
      name = "fix-test-one-cpu.patch";
      url = "https://github.com/sanic-org/sanic/commit/a1df2a6de1c9c88a85d166e7e2636d26f7925852.patch";
      hash = "sha256-vljGuoP/Q9HrP+/AOoI1iUpbDQ4/1Pn7AURP1dncI00=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
=======
    hash = "sha256-Vj780rP5rJ+YsMWlb3BR9LTKT/nTt0C2H3J0X9sysj8=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    aiofiles
<<<<<<< HEAD
    httptools
    html5tagger
    multidict
    sanic-routing
    tracerite
    typing-extensions
=======
    aioquic
    httptools
    multidict
    sanic-routing
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ujson
    uvloop
    websockets
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    ext = [
      # TODO: sanic-ext
    ];
    http3 = [
      aioquic
    ];
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    beautifulsoup4
    gunicorn
    pytest-asyncio
    pytestCheckHook
    sanic-testing
    uvicorn
<<<<<<< HEAD
  ] ++ passthru.optional-dependencies.http3;
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  inherit doCheck;

  preCheck = ''
    # Some tests depends on sanic on PATH
    PATH="$out/bin:$PATH"
    PYTHONPATH=$PWD:$PYTHONPATH

    # needed for relative paths for some packages
    cd tests
  '' + lib.optionalString stdenv.isDarwin ''
    # OSError: [Errno 24] Too many open files
    ulimit -n 1024
  '';

  # uvloop usage is buggy
  #SANIC_NO_UVLOOP = true;

  pytestFlagsArray = [
    "--asyncio-mode=auto"
    "-vvv"
  ];

  disabledTests = [
    # Require networking
    "test_full_message"
    # Server mode mismatch (debug vs production)
    "test_num_workers"
    # Racy tests
    "test_keep_alive_client_timeout"
    "test_keep_alive_server_timeout"
    "test_zero_downtime"
    # sanic.exceptions.SanicException: Cannot setup Sanic Simple Server without a path to a directory
    "test_load_app_simple"
    # create defunct python processes
    "test_reloader_live"
    "test_reloader_live_with_dir"
    "test_reload_listeners"
    # crash the python interpreter
    "test_host_port_localhost"
    "test_host_port"
    "test_server_run"
    # NoneType object is not subscriptable
    "test_serve_app_implicit"
    # AssertionError: assert [] == ['Restarting a process', 'Begin restart termination', 'Starting a process']
    "test_default_reload_shutdown_order"
    # App not found.
    "test_input_is_dir"
  ];

  disabledTestPaths = [
    # We are not interested in benchmarks
    "benchmark/"
<<<<<<< HEAD
    # We are also not interested in typing
    "typing/test_typing.py"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    description = "Web server and web framework";
    homepage = "https://github.com/sanic-org/sanic/";
    changelog = "https://github.com/sanic-org/sanic/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ AluisioASG ];
=======
    maintainers = with maintainers; [ costrouc AluisioASG ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
