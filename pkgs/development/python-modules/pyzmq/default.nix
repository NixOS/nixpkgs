{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,

  # build-system
  cffi,
  cython,
  cmake,
  ninja,
  packaging,
  pathspec,
  scikit-build-core,

  # checks
  pytestCheckHook,
  pythonOlder,
  tornado,
  libsodium,
  zeromq,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "26.2.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F9cqdOXp/zgp3rcol6F1Mz0+9bVBOUjK489+vwsC7Mo=";
  };

  build-system = [
    cmake
    ninja
    packaging
    pathspec
    scikit-build-core
  ] ++ (if isPyPy then [ cffi ] else [ cython ]);

  dontUseCmakeConfigure = true;

  buildInputs = [
    libsodium
    zeromq
  ];

  dependencies = lib.optionals isPyPy [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
    tornado
    pytest-asyncio
  ];

  pythonImportsCheck = [ "zmq" ];

  preCheck = ''
    rm -r zmq
  '';

  pytestFlagsArray = [
    "-m"
    "'not flaky'"
  ];

  disabledTests = [
    # Tests hang
    "test_socket"
    "test_monitor"
    # https://github.com/zeromq/pyzmq/issues/1272
    "test_cython"
    # Test fails
    "test_mockable"
    # Issues with the sandbox
    "TestFutureSocket"
    "TestIOLoop"
    "TestPubLog"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python bindings for ØMQ";
    homepage = "https://pyzmq.readthedocs.io/";
    license = with licenses; [
      bsd3 # or
      lgpl3Only
    ];
    maintainers = [ ];
  };
}
