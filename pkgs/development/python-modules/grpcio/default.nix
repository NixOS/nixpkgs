{ stdenv, buildPythonPackage, darwin, grpc
, six, protobuf, enum34, futures, isPy27, pkgconfig
, cython}:

buildPythonPackage rec {
  inherit (grpc) src version;
  pname = "grpcio";

  nativeBuildInputs = [ cython pkgconfig ]
                    ++ stdenv.lib.optional stdenv.isDarwin darwin.cctools;

  propagatedBuildInputs = [ six protobuf ]
                        ++ stdenv.lib.optionals (isPy27) [ enum34 futures ];

  preBuild = stdenv.lib.optionalString stdenv.isDarwin "unset AR";

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
