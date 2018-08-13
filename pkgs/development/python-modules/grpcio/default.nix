{ stdenv, buildPythonPackage, fetchPypi, lib, darwin
, six, protobuf, enum34, futures, isPy27, isPy34, pkgconfig }:

with stdenv.lib;
buildPythonPackage rec {
  pname = "grpcio";
  version = "1.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bf23666e763ca7ff6010465864e9f088f4ac7ecc1e11abd6f85b250e66b2c05";
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
