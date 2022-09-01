{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, buildPackages
, cmake
, zlib
, c-ares
, pkg-config
, re2
, openssl
, protobuf
, grpc
, abseil-cpp
, libnsl

# tests
, python3
, arrow-cpp
}:

stdenv.mkDerivation rec {
  pname = "grpc";
  version = "1.48.1"; # N.B: if you change this, please update:
    # pythonPackages.grpcio-tools
    # pythonPackages.grpcio-status

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    hash = "sha256-It9oFenKoPDCOVxiKCGJc8i18zdDZCceR22HR5Tu1sw=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build on armv6l (https://github.com/grpc/grpc/pull/21341)
    (fetchpatch {
      url = "https://github.com/grpc/grpc/commit/2f4cf1d9265c8e10fb834f0794d0e4f3ec5ae10e.patch";
      sha256 = "0ams3jmgh9yzwmxcg4ifb34znamr7pb4qm0609kvil9xqvkqz963";
    })

    # Revert gRPC C++ Mutex to be an alias of Abseil, because it breaks dependent packages
    (fetchpatch {
      url = "https://github.com/grpc/grpc/commit/931f91b745cd5b2864a0d1787815871d0bd844ae.patch";
      sha256 = "0vc93g2i4982ys4gzyaxdv9ni25yk10sxq3n7fkz8dypy8sylck7";
      revert = true;
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) grpc;
  propagatedBuildInputs = [ c-ares re2 zlib abseil-cpp ];
  buildInputs = [ c-ares.cmake-config openssl protobuf ]
    ++ lib.optionals stdenv.isLinux [ libnsl ];

  cmakeFlags = [
    "-DgRPC_ZLIB_PROVIDER=package"
    "-DgRPC_CARES_PROVIDER=package"
    "-DgRPC_RE2_PROVIDER=package"
    "-DgRPC_SSL_PROVIDER=package"
    "-DgRPC_PROTOBUF_PROVIDER=package"
    "-DgRPC_ABSL_PROVIDER=package"
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=${buildPackages.protobuf}/bin/protoc"
  ] ++ lib.optionals ((stdenv.hostPlatform.useLLVM or false) && lib.versionOlder stdenv.cc.cc.version "11.0") [
    # Needs to be compiled with -std=c++11 for clang < 11. Interestingly this is
    # only an issue with the useLLVM stdenv, not the darwin stdenv…
    # https://github.com/grpc/grpc/issues/26473#issuecomment-860885484
    "-DCMAKE_CXX_STANDARD=11"
  ];

  # CMake creates a build directory by default, this conflicts with the
  # basel BUILD file on case-insensitive filesystems.
  preConfigure = ''
    rm -vf BUILD
  '';

  # When natively compiling, grpc_cpp_plugin is executed from the build directory,
  # needing to load dynamic libraries from the build directory, so we set
  # LD_LIBRARY_PATH to enable this. When cross compiling we need to avoid this,
  # since it can cause the grpc_cpp_plugin executable from buildPackages to
  # crash if build and host architecture are compatible (e. g. pkgsLLVM).
  preBuild = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    export LD_LIBRARY_PATH=$(pwd)''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  '';

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unknown-warning-option"
    + lib.optionalString stdenv.isAarch64 "-Wno-error=format-security";

  enableParallelBuilds = true;

  passthru.tests = {
    inherit (python3.pkgs) grpcio-status grpcio-tools;
    inherit arrow-cpp;
  };

  meta = with lib; {
    description = "The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 marsam ];
    homepage = "https://grpc.io/";
    platforms = platforms.all;
    changelog = "https://github.com/grpc/grpc/releases/tag/v${version}";
  };
}
