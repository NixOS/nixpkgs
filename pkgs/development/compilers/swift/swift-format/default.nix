{ lib
, stdenv
, callPackage
, swift
, swiftpm
, swiftpm2nix
, Foundation
}:
let
  sources = callPackage ../sources.nix { };
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation {
  pname = "swift-format";

  inherit (sources) version;
  src = sources.swift-format;

  nativeBuildInputs = [ swift swiftpm ];
  buildInputs = [ Foundation ];

  configurePhase = generated.configure;

  # We only install the swift-format binary, so don't need the other products.
<<<<<<< HEAD
  swiftpmFlags = [ "--product swift-format" ];
=======
  swiftpmFlags = "--product swift-format";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    maintainers = with lib.maintainers; [ dtzWill trepetti dduan trundle stephank ];
  };
}
