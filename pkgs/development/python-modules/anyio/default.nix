{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools-scm,

  # dependencies
  exceptiongroup,
  idna,
  sniffio,
  typing-extensions,

  # optionals
  trio,

  # tests
  blockbuster,
  hypothesis,
  psutil,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  trustme,
  uvloop,

  # smoke tests
  starlette,
}:

buildPythonPackage rec {
  pname = "anyio";
  version = "4.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "anyio";
    tag = version;
    hash = "sha256-9nOGQTqdO3VzA9c97BpZqqwpll5O5+3gRvF/l2Y2ars=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    idna
    sniffio
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  optional-dependencies = {
    trio = [ trio ];
  };

  nativeCheckInputs = [
    blockbuster
    exceptiongroup
    hypothesis
    psutil
    pytest-mock
    pytest-xdist
    pytestCheckHook
    trustme
    uvloop
  ]
  ++ optional-dependencies.trio;

  pytestFlags = [
    "-Wignore::trio.TrioDeprecationWarning"
  ];

  disabledTestMarks = [
    "network"
  ];

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Work around "OSError: AF_UNIX path too long"
    export TMPDIR="/tmp"
  '';

  disabledTests = [
    # TypeError: __subprocess_run() got an unexpected keyword argument 'umask'
    "test_py39_arguments"
    # AttributeError: 'module' object at __main__ has no attribute '__file__'
    "test_nonexistent_main_module"
    #  3 second timeout expired
    "test_keyboardinterrupt_during_test"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/dev/console'
    "test_is_block_device"

    # These tests become flaky under heavy load
    "test_asyncio_run_sync_called"
    "test_handshake_fail"
    "test_run_in_custom_limiter"
    "test_cancel_from_shielded_scope"
    "test_start_task_soon_cancel_later"

    # AssertionError: assert 'wheel' == 'nixbld'
    "test_group"
  ];

  disabledTestPaths = [
    # lots of DNS lookups
    "tests/test_sockets.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "anyio" ];

  passthru.tests = {
    inherit starlette;
  };

  meta = with lib; {
    changelog = "https://github.com/agronholm/anyio/blob/${src.tag}/docs/versionhistory.rst";
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
