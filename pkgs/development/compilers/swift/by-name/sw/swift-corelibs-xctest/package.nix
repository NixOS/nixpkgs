{
  lib,
  cmake,
  fetchFromGitHub,
  ninja,
  stdenv,
  swift-corelibs-foundation,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-foundation-icu,
  swift-minimal,
  swift_release,
  swift_sources,
}:

let
  # Our minimum deployment target is higher than 10.12, but we can target lower, and some dependants require it.
  # This is harmless on non-Darwin.
  minTriple =
    lib.replaceString stdenv.hostPlatform.darwinMinVersion "10.12"
      stdenv.hostPlatform.swift.triple;

  # swift-corelibs-xctest requires Dispatch and Foundation.
  swift = swift-minimal.override { inherit swift-corelibs-libdispatch swift-foundation; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-corelibs-xctest";
  version = swift_release;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-corelibs-xctest";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-corelibs-xctest) hash;
  };

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeBool "USE_FOUNDATION_FRAMEWORK" true) ];

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${minTriple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift
  ];

  buildInputs =
    # swift-corelibs-xctest expects to find these via CMake on non-Darwin platforms.
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      swift-corelibs-foundation
      swift-corelibs-libdispatch
      swift-foundation
      swift-foundation-icu
    ];

  postInstall = ''
    dylib_name=libXCTest${stdenv.hostPlatform.extensions.library}
    dylib_path="''${!outputLib}/lib/swift/${stdenv.hostPlatform.swift.platform}"
    mv "$dylib_path/$dylib_name" "''${!outputLib}/lib/$dylib_name"

    moveToOutput lib/swift/${stdenv.hostPlatform.swift.platform} "''${!outputDev}"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool "''${!outputLib}/lib/$dylib_name" \
      -change "$dylib_path/$dylib_name" "''${!outputLib}/lib/$dylib_name"
  '';

  __structuredAttrs = true;

  meta = {
    description = "Framework for writing unit tests in Swift";
    homepage = "https://github.com/swiftlang/swift-corelibs-xctest";
    platforms = lib.platforms.darwin ++ lib.platforms.linux ++ lib.platforms.windows;
    license = lib.licenses.asl20;
    maintainers = lib.teams.swift.members;
  };
})
