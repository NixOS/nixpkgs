{ lib
, stdenv
, callPackage
, pkg-config
, swift
, swiftpm
, swiftpm2nix
, Foundation
, XCTest
, sqlite
, ncurses
, CryptoKit
, LocalAuthentication
}:
let
  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;

  # On Darwin, we only want ncurses in the linker search path, because headers
  # are part of libsystem. Adding its headers to the search path causes strange
  # mixing and errors.
  # TODO: Find a better way to prevent this conflict.
  ncursesInput = if stdenv.isDarwin then ncurses.out else ncurses;
in
stdenv.mkDerivation {
  pname = "sourcekit-lsp";

  inherit (sources) version;
  src = sources.sourcekit-lsp;

  nativeBuildInputs = [ pkg-config swift swiftpm ];
  buildInputs = [
    Foundation
    XCTest
    sqlite
    ncursesInput
  ] ++ lib.optionals stdenv.isDarwin [ CryptoKit LocalAuthentication ];

  configurePhase = generated.configure + ''
    swiftpmMakeMutable indexstore-db
    patch -p1 -d .build/checkouts/indexstore-db -i ${./patches/indexstore-db-macos-target.patch}

    swiftpmMakeMutable swift-tools-support-core
    patch -p1 -d .build/checkouts/swift-tools-support-core -i ${./patches/force-unwrap-file-handles.patch}

    # This toggles a section specific to Xcode XCTest, which doesn't work on
    # Darwin, where we also use swift-corelibs-xctest.
    substituteInPlace Sources/LSPTestSupport/PerfTestCase.swift \
      --replace '#if os(macOS)' '#if false'

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
    homepage = "https://github.com/apple/sourcekit-lsp";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dtzWill trepetti dduan trundle stephank ];
  };
}
