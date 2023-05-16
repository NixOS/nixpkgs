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
<<<<<<< HEAD
  version = "1.57.0"; # N.B: if you change this, please update:
=======
  version = "1.54.0"; # N.B: if you change this, please update:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # pythonPackages.grpcio-tools
    # pythonPackages.grpcio-status

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZPhPi4ODAAohCySVKeypaDID4ZUXvnfidOGK5EMXvh4=";
=======
    hash = "sha256-WVH7rYyFx2LyAnctnNbX4KevoJ5KKZujN+SmL0Y6wvw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      # armv6l support, https://github.com/grpc/grpc/pull/21341
      name = "grpc-link-libatomic.patch";
      url = "https://github.com/lopsided98/grpc/commit/164f55260262c816e19cd2c41b564486097d62fe.patch";
      hash = "sha256-d6kMyjL5ZnEnEz4XZfRgXJBH53gp1r7q1tlwh+HM6+Y=";
    })
<<<<<<< HEAD
    # Fix generated CMake config file
    # FIXME: remove when merged
    (fetchpatch {
      url = "https://github.com/grpc/grpc/pull/33361/commits/117dc80eb43021dd5619023ef6d02d0d6ec7ae7a.patch";
      hash = "sha256-VBk3ZD5h9uOQVN0st+quUQK/wXqvfFNk8G8AN4f2MQo=";
    })
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=${buildPackages.protobuf}/bin/protoc"
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
=======
    "-DCMAKE_CXX_STANDARD=${passthru.cxxStandard}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=${buildPackages.protobuf}/bin/protoc"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unknown-warning-option"
    + lib.optionalString stdenv.isAarch64 "-Wno-error=format-security";

  enableParallelBuilds = true;

<<<<<<< HEAD
=======
  passthru.cxxStandard =
    let
      # Needs to be compiled with -std=c++11 for clang < 11. Interestingly this is
      # only an issue with the useLLVM stdenv, not the darwin stdenv…
      # https://github.com/grpc/grpc/issues/26473#issuecomment-860885484
      useLLVMAndOldCC = (stdenv.hostPlatform.useLLVM or false) && lib.versionOlder stdenv.cc.cc.version "11.0";
      # With GCC 9 (current aarch64-linux) it fails with c++17 but OK with c++14.
      useOldGCC = !(stdenv.hostPlatform.useLLVM or false) && lib.versionOlder stdenv.cc.cc.version "10";
    in
    (if useLLVMAndOldCC then "11" else if useOldGCC then "14" else "17");

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
