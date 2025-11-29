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
  version = "4.12.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "anyio";
    tag = version;
    hash = "sha256-zFVvAK06HG40numRihLHBMKCI3d1wQvmEKk+EaBFVVU=";
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
    # DeprecationWarning for asyncio.iscoroutinefunction is propagated from uvloop used internally
    # https://github.com/agronholm/anyio/commit/e7bb0bd496b1ae0d1a81b86de72312d52e8135ed
    "-Wignore::DeprecationWarning"
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
    # racy with high thread count, see https://github.com/NixOS/nixpkgs/issues/448125
    "test_multiple_threads"
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
