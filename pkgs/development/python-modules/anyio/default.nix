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
  version = "4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "anyio";
    tag = version;
    hash = "sha256-kISaBHDkMOYYU9sdiQAXiq3jp1ehWOYFpvFbuceBWB0=";
  };

  build-system = [ setuptools-scm ];

  dependencies =
    [
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
  ] ++ optional-dependencies.trio;

  pytestFlagsArray = [
    "-W"
    "ignore::trio.TrioDeprecationWarning"
    "-m"
    "'not network'"
  ];

  disabledTests =
    [
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
