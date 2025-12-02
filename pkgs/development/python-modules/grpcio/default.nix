{
  lib,
  stdenv,
  buildPythonPackage,
  c-ares,
  cython,
  fetchPypi,
  openssl,
  pkg-config,
  protobuf,
  typing-extensions,
  pythonOlder,
  setuptools,
  zlib,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio";
  version = "1.76.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e+eDiNbaGiXA1exQZSPbWLGL4i2cN9jToywIvkmHvXM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    c-ares
    openssl
    zlib
  ];

  dependencies = [
    protobuf
    typing-extensions
  ];

  preBuild = ''
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

  meta = with lib; {
    description = "HTTP/2-based RPC framework";
    homepage = "https://grpc.io/grpc/python/";
    changelog = "https://github.com/grpc/grpc/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
