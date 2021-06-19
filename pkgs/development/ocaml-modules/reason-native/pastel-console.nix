{ lib, fetchFromGitHub, buildDunePackage, reason, reason-native-console, reason-native-pastel, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "pastel-console";

  buildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    reason-native-console
    reason-native-pastel
  ];

  meta = shared.meta // {
    description = "Small library for pretty coloring to Console output";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/pastel-console";
    homepage = "https://reason-native.com/docs/pastel/console";
  };
})
