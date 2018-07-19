{ stdenv, buildPythonPackage, fetchPypi, lib
, six, protobuf, enum34, futures, isPy27, isPy34 }:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6324581e215157f0fbe335dff2e21a65b4406db98ac7cca05f1e23b4f510b426";
  };

  propagatedBuildInputs = [ six protobuf ]
                        ++ lib.optionals (isPy27 || isPy34) [ enum34 ]
                        ++ lib.optionals (isPy27) [ futures ];

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = lib.licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
