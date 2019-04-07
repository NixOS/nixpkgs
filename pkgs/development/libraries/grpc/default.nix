{ stdenv, fetchFromGitHub, cmake, zlib, c-ares, pkgconfig, openssl, protobuf, gflags }:

stdenv.mkDerivation rec {
  version = "1.19.0";
  name = "grpc-${version}";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    sha256 = "105hvpn2z3qiyc01wyzpmfbrpmy20kz1nb9j1c2s0kz1r0v92gqi";
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

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=unknown-warning-option";

  enableParallelBuilds = true;

  meta = with stdenv.lib; {
    description = "The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    maintainers = [ maintainers.lnl7 ];
    homepage = https://grpc.io/;
  };
}
