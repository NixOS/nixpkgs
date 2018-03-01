{ stdenv, fetchurl, cmake, zlib, c-ares, pkgconfig, openssl, protobuf, gflags }:

stdenv.mkDerivation rec {
  version = "1.9.1";
  name = "grpc-${version}";
  src = fetchurl {
    url = "https://github.com/grpc/grpc/archive/v${version}.tar.gz";
    sha256 = "0h2w0dckxydngva9kl7dpilif8k9zi2ajnlanscr7s5kkza3dhps";
  };
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ zlib c-ares c-ares.cmake-config openssl protobuf gflags ];
  cmakeFlags =
    [ "-DgRPC_ZLIB_PROVIDER=package"
      "-DgRPC_CARES_PROVIDER=package"
      "-DgRPC_SSL_PROVIDER=package"
      "-DgRPC_PROTOBUF_PROVIDER=package"
      "-DgRPC_GFLAGS_PROVIDER=package"
    ];
  enableParallelBuilds = true;

  meta = with stdenv.lib; {
    description = "The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    homepage = https://grpc.io/;
  };
}
