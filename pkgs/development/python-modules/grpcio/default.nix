{ stdenv, buildPythonPackage, fetchFromGitHub, darwin
, six, protobuf, enum34, futures, isPy27, pkgconfig
, cython}:

buildPythonPackage rec {
  pname = "grpcio";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "18hf794frncqvq3n4j5n8kip0gp6ch4pf5b3n6809q0c1paf6rp5";
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
