{ stdenv, buildPythonPackage, fetchFromGitHub, darwin
, six, protobuf, enum34, futures, isPy27, pkgconfig
, cython}:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "093w8mgvl8ylqlqnfz06ijkmlnkxcjszf9zg6k5ybjw7dwal0jhz";
  };

  nativeBuildInputs = [ cython pkgconfig ]
                    ++ stdenv.lib.optional stdenv.isDarwin darwin.cctools;

  propagatedBuildInputs = [ six protobuf ]
                        ++ stdenv.lib.optionals (isPy27) [ enum34 futures ];

  preBuild = stdenv.lib.optionalString stdenv.isDarwin "unset AR";

  meta = with stdenv.lib; {
    description = "HTTP/2-based RPC framework";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
