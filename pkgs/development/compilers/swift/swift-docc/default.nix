{ lib
, stdenv
, callPackage
, swift
, swiftpm
, swiftpm2nix
, Foundation
, XCTest
, CryptoKit
, LocalAuthentication
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

  nativeBuildInputs = [ swift swiftpm ];
  buildInputs = [ Foundation XCTest ]
    ++ lib.optionals stdenv.isDarwin [ CryptoKit LocalAuthentication ];

  configurePhase = generated.configure;

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
    homepage = "https://github.com/apple/swift-docc";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dtzWill trepetti dduan trundle stephank ];
  };
}
