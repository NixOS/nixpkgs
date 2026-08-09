{
  lib,
  cmake,
  fetchFromGitHub,
  llvm_libtool,
  ninja,
  stdenv,
  swift-argument-parser,
  swift-corelibs-libdispatch,
  swift-foundation,
  swift-llbuild,
  swift-minimal,
  swift-tools-support-core,
  swift_release,
  swift_sources,
}:

let
  swiftPlatform = stdenv.hostPlatform.swift.platform;
  # Swift Driver requires Dispatch and Foundation.
  swift = swift-minimal.override { inherit swift-corelibs-libdispatch swift-foundation; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-driver";
  version = swift_release;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-driver";
    tag = "swift-${finalAttrs.version}-RELEASE";
    inherit (swift_sources.swift-driver) hash;
  };

  patches = [
    ./patches/0001-gnu-install-dirs.patch
    # Adjust the built libraries to match the way SwiftPM would build the Swift Compiler Driver.
    ./patches/0002-Match-SwiftPM-products-when-building-with-CMake.patch
    # Align Swift Driver’s subcommand lookup behavior with the legacy/C++ frontend. Nixpkgs needs this because it
    # builds and installs SwiftPM separately from the rest of the Swift toolchain. Otherwise, `swift build` will fail.
    ./patches/0003-Search-PATH-for-subcommands.patch
    # The stdlib is located at the top-level `lib` folder in the toolchain in Nixpkgs. Help `swift repl` find it there.
    ./patches/0004-Help-the-repl-find-the-stdlib-in-Nixpkgs.patch
  ];

  strictDeps = true;

  preConfigure = ''
    appendToVar cmakeFlags -DCMAKE_Swift_COMPILER_TARGET=${stdenv.hostPlatform.swift.triple}
    appendToVar cmakeFlags -DCMAKE_Swift_FLAGS=-module-cache-path\ "$NIX_BUILD_TOP/module-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    swift
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvm_libtool ];

  buildInputs = [
    swift-argument-parser
    swift-llbuild
    swift-tools-support-core
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";

  #  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
  #    # Rpaths get messed up during build with duplicated ::s that confuses CMake’s install phase.
  #    for f in bin/swift-driver lib/libSwiftDriver.so; do
  #      rpaths=$(patchelf --print-rpath "$f")
  #      patchelf --set-rpath "''${rpaths/::/:}" "$f"
  #    done
  #  '';

  postInstall = ''
    mkdir -p "''${!outputDev}/lib/swift/${swiftPlatform}" "''${!outputLib}/lib"

    # Install the SwiftOptions static library (needed by Swift Build).
    cp -v lib/libSwiftOptions.a "''${!outputLib}/lib"

    # Install the swiftmodule.
    cp -v swift/*.swiftmodule "''${!outputDev}/lib/swift/${swiftPlatform}"

    # Install CMake config file for the Swift Compiler Driver library.
    mkdir -p "''${!outputDev}/lib/cmake/SwiftDriver"
    substitute ${./files/SwiftDriverConfig.cmake} "''${!outputDev}/lib/cmake/SwiftDriver/SwiftDriverConfig.cmake" \
      --replace-fail '@buildType@' ${if stdenv.hostPlatform.isStatic then "STATIC" else "SHARED"} \
      --replace-fail '@dev@' "''${!outputDev}" \
      --replace-fail '@lib@' "''${!outputLib}" \
      --replace-fail '@swiftPlatform@' ${swiftPlatform}
  ''
  # For some reason, these rpaths get dropped during installation phase on Linux.
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for f in "$out/bin/"* "$lib/lib/"*; do
      if isELF "$f"; then
        patchelf --add-rpath ${
          lib.escapeShellArg (
            lib.makeLibraryPath [
              swift-argument-parser
              swift-tools-support-core
              swift-llbuild
            ]
          )
        } "$f"
        patchelf --force-rpath "$f" # Otherwise, libswiftSynchronization.so won’t be found.
      fi
    done
  '';

  __structuredAttrs = true;

  meta = {
    mainProgram = "swift-driver";
    homepage = "https://github.com/swiftlang/swift-driver";
    description = "Swift compiler driver written in Swift";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
