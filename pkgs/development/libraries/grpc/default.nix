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
  version = "1.62.1"; # N.B: if you change this, please update:
    # pythonPackages.grpcio-tools
    # pythonPackages.grpcio-status

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    hash = "sha256-L0bn6Bg36UKIRxznH9o4T7WXUqMwFjr8ybeQfbUi8xM=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      # armv6l support, https://github.com/grpc/grpc/pull/21341
      name = "grpc-link-libatomic.patch";
      url = "https://github.com/lopsided98/grpc/commit/a9b917666234f5665c347123d699055d8c2537b2.patch";
      hash = "sha256-Lm0GQsz/UjBbXXEE14lT0dcRzVmCKycrlrdBJj+KLu8=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) grpc;
  propagatedBuildInputs = [ c-ares re2 zlib abseil-cpp ];
  buildInputs = [ openssl protobuf ]
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
    "-D_gRPC_CPP_PLUGIN=${buildPackages.grpc}/bin/grpc_cpp_plugin"
  ]
  # The build scaffold defaults to c++14 on darwin, even when the compiler uses
  # a more recent c++ version by default [1]. However, downgrades are
  # problematic, because the compatibility types in abseil will have different
  # interface definitions than the ones used for building abseil itself.
  # [1] https://github.com/grpc/grpc/blob/v1.57.0/CMakeLists.txt#L239-L243
  ++ (let
    defaultCxxIsOlderThan17 =
      (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.cc.version "16.0")
       || (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.cc.version "11.0");
    in lib.optionals (stdenv.hostPlatform.isDarwin && defaultCxxIsOlderThan17)
  [
    "-DCMAKE_CXX_STANDARD=17"
  ]);

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

  env.NIX_CFLAGS_COMPILE = toString ([
    "-Wno-error"
  ] ++ lib.optionals stdenv.isDarwin [
    # Workaround for https://github.com/llvm/llvm-project/issues/48757
    "-Wno-elaborated-enum-base"
  ]);

  enableParallelBuilds = true;

  passthru.tests = {
    inherit (python3.pkgs) grpcio-status grpcio-tools jaxlib;
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
