# The cmake version of this build is meant to enable both cmake and .pc being exported
# this is important because grpc exports a .cmake file which also expects for protobuf
# to have been exported through cmake as well.
{ lib
, stdenv
, abseil-cpp
, buildPackages
, cmake
, fetchFromGitHub
, fetchpatch
, gtest
, zlib
, version
, hash

  # downstream dependencies
, python3
, grpc
, enableShared ? !stdenv.hostPlatform.isStatic

, ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protobuf";
  inherit version;

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "v${version}";
    inherit hash;
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  patches = lib.optionals (lib.versionOlder version "22") [
    # fix protobuf-targets.cmake installation paths, and allow for CMAKE_INSTALL_LIBDIR to be absolute
    # https://github.com/protocolbuffers/protobuf/pull/10090
    (fetchpatch {
      url = "https://github.com/protocolbuffers/protobuf/commit/a7324f88e92bc16b57f3683403b6c993bf68070b.patch";
      hash = "sha256-SmwaUjOjjZulg/wgNmR/F5b8rhYA2wkKAjHIOxjcQdQ=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    ./static-executables-have-no-rpath.patch
  ];

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # protoc of the same version must be available for build. For non-cross builds, it's able to
    # re-use the executable generated as part of the build
    buildPackages."protobuf_${lib.versions.major version}"
  ];

  buildInputs = [
    gtest
    zlib
  ];

  propagatedBuildInputs = [
    abseil-cpp
  ];

  strictDeps = true;

  cmakeDir = if lib.versionOlder version "22" then "../cmake" else null;
  cmakeFlags = [
    "-Dprotobuf_USE_EXTERNAL_GTEST=ON"
    "-Dprotobuf_ABSL_PROVIDER=package"
  ] ++ lib.optionals enableShared [
    "-Dprotobuf_BUILD_SHARED_LIBS=ON"
  ]
  # Tests fail to build on 32-bit platforms; fixed in 22.x
  # https://github.com/protocolbuffers/protobuf/issues/10418
  ++ lib.optionals (stdenv.hostPlatform.is32bit && lib.versionOlder version "22") [
    "-Dprotobuf_BUILD_TESTS=OFF"
  ];

  # FIXME: investigate.  24.x and 23.x have different errors.
  # At least some of it is not reproduced on some other machine; example:
  # https://hydra.nixos.org/build/235677717/nixlog/4/tail
  # Also AnyTest.TestPackFromSerializationExceedsSizeLimit fails on 32-bit platforms
  # https://github.com/protocolbuffers/protobuf/issues/8460
  doCheck = !(stdenv.isDarwin && lib.versionAtLeast version "23") && !stdenv.hostPlatform.is32bit;

  passthru = {
    tests = {
      pythonProtobuf = python3.pkgs.protobuf.override (_: {
        protobuf = finalAttrs.finalPackage;
      });
      inherit grpc;
    };

    inherit abseil-cpp;
  };

  meta = {
    description = "Google's data interchange format";
    longDescription = ''
      Protocol Buffers are a way of encoding structured data in an efficient
      yet extensible format. Google uses Protocol Buffers for almost all of
      its internal RPC protocols and file formats.
    '';
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    homepage = "https://protobuf.dev/";
    maintainers = with lib.maintainers; [ jonringer ];
    mainProgram = "protoc";
  };
})
