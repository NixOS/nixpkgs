{ stdenv, buildPythonPackage, darwin, grpc
, six, protobuf, enum34, futures, isPy27, pkgconfig
, cython, c-ares, openssl, zlib }:

buildPythonPackage rec {
  inherit (grpc) src version;
  pname = "grpcio";

  nativeBuildInputs = [ cython pkgconfig ]
                    ++ stdenv.lib.optional stdenv.isDarwin darwin.cctools;

  buildInputs = [ c-ares openssl zlib ];
  propagatedBuildInputs = [ six protobuf ]
                        ++ stdenv.lib.optionals (isPy27) [ enum34 futures ];

  preBuild = stdenv.lib.optionalString stdenv.isDarwin "unset AR";

  GRPC_PYTHON_BUILD_SYSTEM_OPENSSL = 1;
  GRPC_PYTHON_BUILD_SYSTEM_ZLIB = 1;
  GRPC_PYTHON_BUILD_SYSTEM_CARES = 1;

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
