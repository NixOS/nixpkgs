{ stdenv, buildPythonPackage, fetchPypi, lib
, six, protobuf, enum34, futures, isPy26, isPy27, isPy34 }:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1075abnm2nrs69dycsiyi5h84g47yx389xiy9h96zwlvsdr589h3";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'protobuf>=3.5.0.post1'" "'protobuf'"
  '';

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
