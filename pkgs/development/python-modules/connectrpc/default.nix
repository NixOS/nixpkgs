{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  protobuf-py,
  pyqwest,

  # tests
  asgiref,
  brotli,
  protobuf,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "connectrpc";
  version = "0.11.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z0ltm1HZH2hFhKiAMaaoz9EVqzbxASLZ6wRpQx9XU0Q=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    # Upstream pins protobuf-py to this exact version; bump the two together.
    protobuf-py
    pyqwest
  ];

  # The top-level module only re-exports __version__, so import the submodules
  # that actually pull in pyqwest and protobuf.
  pythonImportsCheck = [
    "connectrpc.client"
    "connectrpc.server"
  ];

  nativeCheckInputs = [
    asgiref
    brotli
    # connectrpc.compat bridges to google's protobuf runtime.
    protobuf
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    zstandard
  ];

  disabledTestPaths = [
    # Drives the example Flask app from the unpublished `example` workspace member.
    "test/test_example.py"
    # Needs `pyvoy`, which is not packaged in nixpkgs.
    "test/test_grpc.py"
  ];

  meta = {
    description = "Server and client runtime library for Connect RPC";
    homepage = "https://github.com/connectrpc/connect-py";
    changelog = "https://github.com/connectrpc/connect-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mishushakov ];
  };
})
