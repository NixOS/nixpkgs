{ stdenv, buildPythonPackage, fetchPypi, lib
, six, protobuf, enum34, futures, isPy26, isPy27, isPy34 }:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b61d3a7c45aa08f15dfa735a6a8282b5097be91ff36ad347594d3945ffc12181";
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
