{ lib, fetchFromGitHub, buildDunePackage, reason, reason-native-fp, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "dir";

  buildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    reason-native-fp
  ];

  meta = shared.meta // {
    description = "A library that provides a consistent API for common system, user and application directories consistently on all platforms";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/dir";
  };
})
