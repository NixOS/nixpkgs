{ stdenv, buildPythonPackage, fetchPypi, lib, darwin
, six, protobuf, enum34, futures, isPy27, isPy34, pkgconfig }:

with stdenv.lib;
buildPythonPackage rec {
  pname = "grpcio";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cc5f2d3ee21c642d8982f197c83053fd3a8cbcd6a60240d8c87c6c256b10d57";
  };

  nativeBuildInputs = [ pkgconfig ] ++ optional stdenv.isDarwin darwin.cctools;

  propagatedBuildInputs = [ six protobuf ]
                        ++ lib.optionals (isPy27 || isPy34) [ enum34 ]
                        ++ lib.optionals (isPy27) [ futures ];

  preBuild = optionalString stdenv.isDarwin "unset AR";

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = lib.licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
