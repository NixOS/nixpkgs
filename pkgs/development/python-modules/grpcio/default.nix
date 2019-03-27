{ stdenv, buildPythonPackage, fetchFromGitHub, lib, darwin
, six, protobuf, enum34, futures, isPy27, isPy34, pkgconfig
, cython}:

with stdenv.lib;
buildPythonPackage rec {
  pname = "grpcio";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0cilbhk35gv46mk40jl5f3iqa94x14qyxbavpfq0kh0rld82nx4m";
  };

  nativeBuildInputs = [ cython pkgconfig ]
                    ++ optional stdenv.isDarwin darwin.cctools;

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
