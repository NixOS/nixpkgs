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
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tAI5zk0yzse7463mm78B6VGVnc/WCQ06iKyovWdoRK0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "timeout = 1800  # 30 min" 'timeout = "1800"'
  '';

  build-system = [ uv-build ];

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
