{ stdenv, fetchFromGitHub, cmake, zlib, c-ares, pkgconfig, openssl, protobuf, gflags }:

stdenv.mkDerivation rec {
  version = "1.23.0"; # N.B: if you change this, change pythonPackages.grpcio and pythonPackages.grpcio-tools to a matching version too
  pname = "grpc";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    sha256 = "14svfy7lvz8lf6b7zg1fbypj2n46n9gq0ldgnv85jm0ikv72cgv6";
  };
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ zlib c-ares c-ares.cmake-config openssl protobuf gflags ];

  cmakeFlags =
    [ "-DgRPC_ZLIB_PROVIDER=package"
      "-DgRPC_CARES_PROVIDER=package"
      "-DgRPC_SSL_PROVIDER=package"
      "-DgRPC_PROTOBUF_PROVIDER=package"
      "-DgRPC_GFLAGS_PROVIDER=package"
      "-DBUILD_SHARED_LIBS=ON"
      "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    ];

  # CMake creates a build directory by default, this conflicts with the
  # basel BUILD file on case-insensitive filesystems.
  preConfigure = ''
    rm -vf BUILD
  '';

  preBuild = ''
    export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=unknown-warning-option";

  enableParallelBuilds = true;

  meta = with stdenv.lib; {
    description = "The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    maintainers = [ maintainers.lnl7 maintainers.marsam ];
    homepage = https://grpc.io/;
  };
}
