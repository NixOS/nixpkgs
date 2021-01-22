{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, c-ares, pkg-config, openssl, protobuf
, gflags, abseil-cpp, libnsl
}:

stdenv.mkDerivation rec {
  version = "1.34.1"; # N.B: if you change this, change pythonPackages.grpcio-tools to a matching version too
  pname = "grpc";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    sha256 = "0p6si9i0gg885ag2x87a7jyzhgd5lhx2bh2vjj2ra1jn6y3vg6qk";
    fetchSubmodules = true;
  };
  patches = [
    # Fix build on armv6l (https://github.com/grpc/grpc/pull/21341)
    (fetchpatch {
      url = "https://github.com/grpc/grpc/commit/2f4cf1d9265c8e10fb834f0794d0e4f3ec5ae10e.patch";
      sha256 = "0ams3jmgh9yzwmxcg4ifb34znamr7pb4qm0609kvil9xqvkqz963";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ zlib c-ares c-ares.cmake-config openssl protobuf gflags abseil-cpp ]
    ++ lib.optionals stdenv.isLinux [ libnsl ];

  cmakeFlags =
    [ "-DgRPC_ZLIB_PROVIDER=package"
      "-DgRPC_CARES_PROVIDER=package"
      "-DgRPC_SSL_PROVIDER=package"
      "-DgRPC_PROTOBUF_PROVIDER=package"
      "-DgRPC_GFLAGS_PROVIDER=package"
      "-DgRPC_ABSL_PROVIDER=package"
      "-DBUILD_SHARED_LIBS=ON"
      "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    ];

  # CMake creates a build directory by default, this conflicts with the
  # basel BUILD file on case-insensitive filesystems.
  preConfigure = ''
    rm -vf BUILD
  '';

  preBuild = ''
    export LD_LIBRARY_PATH=$(pwd)''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  '';

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unknown-warning-option";

  enableParallelBuilds = true;

  meta = with lib; {
    description = "The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    maintainers = [ maintainers.lnl7 maintainers.marsam ];
    homepage = "https://grpc.io/";
    platforms = platforms.all;
    changelog = "https://github.com/grpc/grpc/releases/tag/v${version}";
  };
}
