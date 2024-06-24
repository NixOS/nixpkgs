{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  grpc,
  six,
  protobuf,
  enum34 ? null,
  futures ? null,
  isPy27,
  pkg-config,
  cython,
  c-ares,
  openssl,
  zlib,
}:

buildPythonPackage rec {
  pname = "grpcio";
  format = "setuptools";
  version = "1.62.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x3YYBx2Wt6i+LBBwGphTeCO5xluiVsC5Bn4FlM29lU0=";
  };

  outputs = [
    "out"
    "dev"
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
  propagatedBuildInputs =
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
    + lib.optionalString stdenv.isDarwin ''
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
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
