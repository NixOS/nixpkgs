{ stdenv, buildPythonPackage, fetchPypi, lib
, six, protobuf, enum34, futures, isPy26, isPy27, isPy34 }:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ce5fd3093ddc09a152981d5c477ac645eda19dfcc819e45d8c57da6b743bd53";
  };

  propagatedBuildInputs = [ six protobuf ]
                        ++ lib.optionals (isPy26 || isPy27 || isPy34) [ enum34 ]
                        ++ lib.optionals (isPy26 || isPy27) [ futures ];

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = lib.licenses.bsd3;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
