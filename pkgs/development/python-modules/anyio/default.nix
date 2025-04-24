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
  version = "4.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "anyio";
    rev = "refs/tags/${version}";
    hash = "sha256-8QLOAjQpiNtbd+YSHfqcBVdtMSGJFRevOcacZErKuso=";
  };

  build-system = [ setuptools-scm ];

  dependencies =
    [
      idna
      sniffio
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      exceptiongroup
      typing-extensions
    ];

  optional-dependencies = {
    trio = [ trio ];
  };

  nativeCheckInputs = [
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
    changelog = "https://github.com/agronholm/anyio/blob/${src.rev}/docs/versionhistory.rst";
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
