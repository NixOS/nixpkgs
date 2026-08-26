{
  lib,
  stdenv,
  callPackage,
  swift,
  swiftpm,
  swiftpm2nix,
  Foundation,
  XCTest,
}:
let
  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation {
  pname = "swift-docc";

  inherit (sources) version;
  src = sources.swift-docc;
  # TODO: We could build this from `apple/swift-docc-render` source, but that
  # repository is not tagged.
  renderArtifact = sources.swift-docc-render-artifact;

  nativeBuildInputs = [
    swift
    swiftpm
  ];
  buildInputs = [
    Foundation
    XCTest
  ];

  configurePhase =
    generated.configure
    # Fix the build with modern Clang.
    #
    # Based on the upstream fix for Musl:
    # <https://github.com/apple/swift-nio/commit/fc6e3c0eefb28adf641531180b81aaf41b02ed20>
    + ''
      swiftpmMakeMutable swift-nio
      patch -p1 -d .build/checkouts/swift-nio -i ${./fix-swift-nio.patch}
    '';

  # We only install the docc binary, so don't need the other products.
  # This works around a failure building generate-symbol-graph:
  #  Sources/generate-symbol-graph/main.swift:13:18: error: module 'SwiftDocC' was not compiled for testing
  # TODO: Figure out the cause. It doesn't seem to happen outside Nixpkgs.
  swiftpmFlags = [ "--product docc" ];

  # TODO: Tests depend on indexstore-db being provided by an existing Swift
  # toolchain. (ie. looks for `../lib/libIndexStore.so` relative to swiftc.
  #doCheck = true;

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin $out/share/docc
    cp $binPath/docc $out/bin/
    ln -s $renderArtifact/dist $out/share/docc/render
  '';

  # Canary to verify output of our Swift toolchain does not depend on the Swift
  # compiler itself. (Only its 'lib' output.)
  disallowedRequisites = [ swift.swift ];

  meta = {
    description = "Documentation compiler for Swift";
    mainProgram = "docc";
    homepage = "https://github.com/apple/swift-docc";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
}
