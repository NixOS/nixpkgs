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
  tornado,
  libsodium,
  zeromq,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzmq";
  version = "27.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VNQlnRv64k7Ntcp596zC6sbChqAtagrmF3l8tF8HJtM=";
  };

  build-system = [
    cmake
    ninja
    packaging
    pathspec
    scikit-build-core
  ]
  ++ (if isPyPy then [ cffi ] else [ cython ]);

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

  disabledTestMarks = [
    "flaky"
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

  meta = {
    description = "Python bindings for ØMQ";
    homepage = "https://pyzmq.readthedocs.io/";
    changelog = "https://pyzmq.readthedocs.io/en/latest/changelog.html";
    license = with lib.licenses; [
      bsd3 # or
      lgpl3Only
    ];
    maintainers = [ ];
  };
})
