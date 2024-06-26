{
  lib,
  stdenv,
  fetchpatch,
  callPackage,
  swift,
  swiftpm,
  swiftpm2nix,
  Foundation,
}:
let
  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation {
  pname = "swift-format";

  inherit (sources) version;
  src = sources.swift-format;

  nativeBuildInputs = [
    swift
    swiftpm
  ];
  buildInputs = [ Foundation ];

  configurePhase =
    generated.configure
    + ''
      swiftpmMakeMutable swift-tools-support-core
      patch -p1 -d .build/checkouts/swift-tools-support-core -i ${
        fetchpatch {
          url = "https://github.com/apple/swift-tools-support-core/commit/990afca47e75cce136d2f59e464577e68a164035.patch";
          hash = "sha256-PLzWsp+syiUBHhEFS8+WyUcSae5p0Lhk7SSRdNvfouE=";
          includes = [ "Sources/TSCBasic/FileSystem.swift" ];
        }
      }
    '';

  # We only install the swift-format binary, so don't need the other products.
  swiftpmFlags = [ "--product swift-format" ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/swift-format $out/bin/
  '';

  meta = {
    description = "Formatting technology for Swift source code";
    homepage = "https://github.com/apple/swift-format";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dtzWill
      trepetti
      dduan
      trundle
      stephank
    ];
    mainProgram = "swift-format";
  };
}
