{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
<<<<<<< HEAD

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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, trustme
, uvloop
}:

buildPythonPackage rec {
  pname = "anyio";
<<<<<<< HEAD
  version = "3.7.1";
  format = "pyproject";

=======
  version = "3.6.2";
  format = "pyproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-9/pAcVTzw9v57E5l4d8zNyBJM+QNGEuLKrQ0WUBW5xw=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
    hash = "sha256-bootaulvx9zmobQGDirsMz5uxuLeCD9ggAvYkPaKnWo=";
  };

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION=${version}
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    idna
    sniffio
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  passthru.optional-dependencies = {
    trio = [
      trio
    ];
  };

=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # trustme uses pyopenssl
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  nativeCheckInputs = [
<<<<<<< HEAD
    hypothesis
    psutil
    pytest-mock
    pytest-xdist
    pytestCheckHook
    trustme
  ] ++ lib.optionals (pythonOlder "3.12") [
    uvloop
  ] ++ passthru.optional-dependencies.trio;

  pytestFlagsArray = [
    "-W" "ignore::trio.TrioDeprecationWarning"
    "-m" "'not network'"
  ];

  disabledTests = [
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # INTERNALERROR> AttributeError: 'NonBaseMultiError' object has no attribute '_exceptions'. Did you mean: 'exceptions'?
    "test_exception_group_children"
    "test_exception_group_host"
    "test_exception_group_filtering"
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/dev/console'
    "test_is_block_device"
=======
    # regression in python 3.11.3 and 3.10.11
    # https://github.com/agronholm/anyio/issues/550
    "TestTLSStream"
    "TestTLSListener"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTestPaths = [
    # lots of DNS lookups
    "tests/test_sockets.py"
<<<<<<< HEAD
  ];

  __darwinAllowLocalNetworking = true;

=======
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin sandboxing limitations
    "tests/streams/test_tls.py"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "anyio" ];

  meta = with lib; {
    changelog = "https://github.com/agronholm/anyio/blob/${src.rev}/docs/versionhistory.rst";
    description = "High level compatibility layer for multiple asynchronous event loop implementations on Python";
    homepage = "https://github.com/agronholm/anyio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
