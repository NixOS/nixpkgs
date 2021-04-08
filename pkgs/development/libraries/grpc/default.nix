{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, c-ares, pkg-config, re2, openssl, protobuf
, abseil-cpp, libnsl
}:

stdenv.mkDerivation rec {
  version = "1.37.0"; # N.B: if you change this, change pythonPackages.grpcio-tools to a matching version too
  pname = "grpc";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    sha256 = "0q3hcnq351j0qm0gsbaxbsnz1gd9w3bk4cazkvq4l2lfmmiw7z56";
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
  propagatedBuildInputs = [ c-ares re2 zlib abseil-cpp ];
  buildInputs = [ c-ares.cmake-config openssl protobuf ]
    ++ lib.optionals stdenv.isLinux [ libnsl ];

  cmakeFlags =
    [ "-DgRPC_ZLIB_PROVIDER=package"
      "-DgRPC_CARES_PROVIDER=package"
      "-DgRPC_RE2_PROVIDER=package"
      "-DgRPC_SSL_PROVIDER=package"
      "-DgRPC_PROTOBUF_PROVIDER=package"
      "-DgRPC_ABSL_PROVIDER=package"
      "-DBUILD_SHARED_LIBS=ON"
      "-DCMAKE_SKIP_BUILD_RPATH=OFF"
      "-DCMAKE_CXX_STANDARD=17"
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
