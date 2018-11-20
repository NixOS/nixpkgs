{ stdenv, buildPythonPackage, fetchPypi, lib, darwin
, six, protobuf, enum34, futures, isPy27, isPy34, pkgconfig }:

with stdenv.lib;
buildPythonPackage rec {
  pname = "grpcio";
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41bf456665d666d0a07cb1b363626745dc1a98b02395acd666b36c929133a72a";
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
