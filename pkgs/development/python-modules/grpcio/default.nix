{ lib, stdenv
, buildPythonPackage
, fetchpatch
, grpc
, six
, protobuf
, enum34 ? null
, futures ? null
, isPy27
, pkg-config
, cython
, c-ares
, openssl
, zlib
}:

buildPythonPackage rec {
  inherit (grpc) src version;
  pname = "grpcio";

  patches = [
    # Fix build on armv6l
    # https://github.com/grpc/grpc/pull/30401
    (fetchpatch {
      url = "https://github.com/grpc/grpc/commit/65dc9f3edeee4c2d0e9b30d5a3ee63175437bea3.patch";
      hash = "sha256-pS4FsCcSjmjSs3J5Y96UonkxqPwfpkyhrEM0t6HaMd0=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cython pkg-config ];

  buildInputs = [ c-ares openssl zlib ];
  propagatedBuildInputs = [ six protobuf ]
    ++ lib.optionals (isPy27) [ enum34 futures ];

  preBuild = lib.optionalString stdenv.isDarwin "unset AR";

  GRPC_BUILD_WITH_BORING_SSL_ASM = "";
  GRPC_PYTHON_BUILD_SYSTEM_OPENSSL = 1;
  GRPC_PYTHON_BUILD_SYSTEM_ZLIB = 1;
  GRPC_PYTHON_BUILD_SYSTEM_CARES = 1;

  # does not contain any tests
  doCheck = false;

  pythonImportsCheck = [ "grpc" ];

  meta = with lib; {
    description = "HTTP/2-based RPC framework";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
