{ stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, c-ares, pkgconfig, openssl, protobuf, gflags }:

stdenv.mkDerivation rec {
  version = "1.25.0"; # N.B: if you change this, change pythonPackages.grpcio and pythonPackages.grpcio-tools to a matching version too
  pname = "grpc";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    sha256 = "02nbmbk1xpibjzvbhi8xpazmwry46ki24vks1sh2p0aqwy4hv6yb";
    fetchSubmodules = true;
  };
  patches = [
    # Fix build on armv6l (https://github.com/grpc/grpc/pull/21341)
    (fetchpatch {
      url = "https://github.com/grpc/grpc/commit/ffb8a278389c8e3403b23a9897b65a7390c34645.patch";
      sha256 = "1lc12a3gccg9wxqhnwgldlj3zmlm6lxg8dssvvj1x7hf655kw3w3";
    })
  ];

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
