{ stdenv, fetchurl, cmake, zlib, c-ares, pkgconfig, openssl, protobuf, gflags }:

stdenv.mkDerivation rec {
  version = "1.15.0";
  name = "grpc-${version}";
  src = fetchurl {
    url = "https://github.com/grpc/grpc/archive/v${version}.tar.gz";
    sha256 = "0jv3p7i047ay6jak4i9fr9fs39w760hfl4ls0mzgih2i7i7w6g01";
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

  # CMake creates a build directory by default, this conflicts with the
  # basel BUILD file on case-insensitive filesystems.
  preConfigure = ''
    rm -vf BUILD
  '';

  enableParallelBuilds = true;

  meta = with stdenv.lib; {
    description = "The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    maintainers = [ maintainers.lnl7 ];
    homepage = https://grpc.io/;
  };
}
