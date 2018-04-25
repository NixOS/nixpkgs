{ stdenv, buildPythonPackage, fetchPypi, lib
, six, protobuf3_5, enum34, futures, isPy26, isPy27, isPy34 }:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7c43b5619deff48cc177c1b0618c4beeb2797f910f160e3c2035d5baf790a5d";
  };

  propagatedBuildInputs = [ six protobuf3_5 ]
                        ++ lib.optionals (isPy26 || isPy27 || isPy34) [ enum34 ]
                        ++ lib.optionals (isPy26 || isPy27) [ futures ];

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = lib.licenses.bsd3;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
