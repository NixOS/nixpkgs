{ stdenv, buildPythonPackage, fetchPypi, lib
, six, protobuf, enum34, futures, isPy26, isPy27, isPy34 }:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wkrxj1jmf2dyx207fc9ysyns9h27gls3drgg05mzdckjqr5lnl6";
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
