{
  lib,
  stdenv,
  callPackage,
  fetchpatch,
  pkg-config,
  swift,
  swiftpm,
  swiftpm2nix,
  Foundation,
  XCTest,
  sqlite,
  ncurses,
}:
let
  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;

  # On Darwin, we only want ncurses in the linker search path, because headers
  # are part of libsystem. Adding its headers to the search path causes strange
  # mixing and errors.
  # TODO: Find a better way to prevent this conflict.
  ncursesInput = if stdenv.hostPlatform.isDarwin then ncurses.out else ncurses;
in
stdenv.mkDerivation {
  pname = "sourcekit-lsp";

  inherit (sources) version;
  src = sources.sourcekit-lsp;

  nativeBuildInputs = [
    pkg-config
    swift
    swiftpm
  ];
  buildInputs = [
    Foundation
    XCTest
    sqlite
    ncursesInput
  ];

  configurePhase = generated.configure + ''
    swiftpmMakeMutable indexstore-db
    patch -p1 -d .build/checkouts/indexstore-db -i ${./patches/indexstore-db-macos-target.patch}
    patch -p1 -d .build/checkouts/indexstore-db -i ${
      # Fix the build with modern Clang.
      fetchpatch {
        url = "https://github.com/swiftlang/indexstore-db/commit/6120b53b1e8774ef4e2ad83438d4d94961331e72.patch";
        hash = "sha256-tMAfTIa3RKiA/jDtP02mHcpPaF2s9a+3q/PLJxqn30M=";
      }
    }

    swiftpmMakeMutable swift-tools-support-core
    patch -p1 -d .build/checkouts/swift-tools-support-core -i ${
      fetchpatch {
        url = "https://github.com/apple/swift-tools-support-core/commit/990afca47e75cce136d2f59e464577e68a164035.patch";
        hash = "sha256-PLzWsp+syiUBHhEFS8+WyUcSae5p0Lhk7SSRdNvfouE=";
        includes = [ "Sources/TSCBasic/FileSystem.swift" ];
      }
    }

    # This toggles a section specific to Xcode XCTest, which doesn't work on
    # Darwin, where we also use swift-corelibs-xctest.
    substituteInPlace Sources/LSPTestSupport/PerfTestCase.swift \
      --replace-fail '#if os(macOS)' '#if false'

    # Required to link with swift-corelibs-xctest on Darwin.
    export SWIFTTSC_MACOS_DEPLOYMENT_TARGET=10.12
  '';

  # TODO: BuildServerBuildSystemTests fails
  #doCheck = true;

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/sourcekit-lsp $out/bin/
  '';

  # Canary to verify output of our Swift toolchain does not depend on the Swift
  # compiler itself. (Only its 'lib' output.)
  disallowedRequisites = [ swift.swift ];

  meta = {
    description = "Language Server Protocol implementation for Swift and C-based languages";
    mainProgram = "sourcekit-lsp";
    homepage = "https://github.com/apple/sourcekit-lsp";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
}
