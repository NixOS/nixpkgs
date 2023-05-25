{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
, idna
, sniffio
, typing-extensions
, curio
, hypothesis
, mock
, pytest-mock
, pytest-xdist
, pytestCheckHook
, trio
, trustme
, uvloop
}:

buildPythonPackage rec {
  pname = "anyio";
  version = "3.6.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
    hash = "sha256-bootaulvx9zmobQGDirsMz5uxuLeCD9ggAvYkPaKnWo=";
  };

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION=${version}
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    idna
    sniffio
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # trustme uses pyopenssl
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  nativeCheckInputs = [
    curio
    hypothesis
    pytest-mock
    pytest-xdist
    pytestCheckHook
    trio
    trustme
    uvloop
  ] ++ lib.optionals (pythonOlder "3.8") [
    mock
  ];

  pytestFlagsArray = [
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  disabledTests = [
    # block devices access
    "test_is_block_device"
    # INTERNALERROR> AttributeError: 'NonBaseMultiError' object has no attribute '_exceptions'. Did you mean: 'exceptions'?
    "test_exception_group_children"
    "test_exception_group_host"
    "test_exception_group_filtering"
    # regression in python 3.11.3 and 3.10.11
    # https://github.com/agronholm/anyio/issues/550
    "TestTLSStream"
    "TestTLSListener"
  ];

  disabledTestPaths = [
    # lots of DNS lookups
    "tests/test_sockets.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin sandboxing limitations
    "tests/streams/test_tls.py"
  ];

  pythonImportsCheck = [ "anyio" ];

  meta = with lib; {
    changelog = "https://github.com/agronholm/anyio/blob/${src.rev}/docs/versionhistory.rst";
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
