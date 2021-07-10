{ lib, fetchFromGitHub, buildDunePackage, reason, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "fp";

  buildInputs = [
    reason
  ];

  meta = shared.meta // {
    description = "A library for creating and operating on file paths consistently on multiple platforms";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/fp";
  };
})
