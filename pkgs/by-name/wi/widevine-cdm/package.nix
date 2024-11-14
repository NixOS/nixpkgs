{ stdenv, callPackage }:

callPackage (./. + "/${stdenv.hostPlatform.system}.nix") { inherit stdenv; }
