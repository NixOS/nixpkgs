{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools
, setuptools-scm

# dependencies
, exceptiongroup
, idna
, sniffio

# optionals
, trio

# tests
, hypothesis
, psutil
, pytest-mock
, pytest-xdist
, pytestCheckHook
, trustme
, uvloop
}:

buildPythonPackage rec {
  pname = "anyio";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PEDPliWJX3QypwsvJTAJhrQnJx8lWXQQSdyjN0I8L+I=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    idna
    sniffio
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  passthru.optional-dependencies = {
    trio = [
      trio
    ];
  };

  # trustme uses pyopenssl
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  nativeCheckInputs = [
    exceptiongroup
    hypothesis
    psutil
    pytest-mock
    pytest-xdist
    pytestCheckHook
    trustme
    uvloop
  ] ++ passthru.optional-dependencies.trio;

  pytestFlagsArray = [
    "-W" "ignore::trio.TrioDeprecationWarning"
    "-m" "'not network'"
  ];

  disabledTests = [
    # INTERNALERROR> AttributeError: 'NonBaseMultiError' object has no attribute '_exceptions'. Did you mean: 'exceptions'?
    "test_exception_group_children"
    "test_exception_group_host"
    "test_exception_group_filtering"
    # timing sensitive
    # assert threading.active_count() == initial_count + 1
    # assert 4 == (4 + 1)
    "test_run_sync_from_thread_pooling"
  ] ++ lib.optionals stdenv.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/dev/console'
    "test_is_block_device"
  ];

  disabledTestPaths = [
    # lots of DNS lookups
    "tests/test_sockets.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "anyio" ];

  meta = with lib; {
    changelog = "https://github.com/agronholm/anyio/blob/${src.rev}/docs/versionhistory.rst";
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
