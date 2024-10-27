{
  lib,
  stdenv,
  grpc,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # nativeBuildInputs
  cython,
  pkg-config,

  # buildInputs
  c-ares,
  openssl,
  zlib,

  # dependencies
  six,
  protobuf,
  isPy27,
  enum34 ? null,
  futures ? null,
}:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.66.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NTNPnJdFrdPjV+M3J1b9MtklvVLEHal/Tf2vveC/DuI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    c-ares
    openssl
    zlib
  ];
  dependencies =
    [
      six
      protobuf
    ]
    ++ lib.optionals (isPy27) [
      enum34
      futures
    ];

  preBuild =
    ''
      export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$NIX_BUILD_CORES"
      if [ -z "$enableParallelBuilding" ]; then
        GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS=1
      fi
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      unset AR
    '';

  GRPC_BUILD_WITH_BORING_SSL_ASM = "";
  GRPC_PYTHON_BUILD_SYSTEM_OPENSSL = 1;
  GRPC_PYTHON_BUILD_SYSTEM_ZLIB = 1;
  GRPC_PYTHON_BUILD_SYSTEM_CARES = 1;

  # does not contain any tests
  doCheck = false;

  enableParallelBuilding = true;

  pythonImportsCheck = [ "grpc" ];

  meta = {
    description = "HTTP/2-based RPC framework";
    license = lib.licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    changelog = "https://github.com/grpc/grpc/releases/tag/v${version}";
    maintainers = [ ];
  };
}
