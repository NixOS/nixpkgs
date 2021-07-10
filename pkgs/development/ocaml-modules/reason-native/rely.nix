{ lib, fetchFromGitHub, buildDunePackage, re, reason, reason-native-file-context-printer, reason-native-pastel, ... }:

let
  shared = import ./shared.nix { inherit lib fetchFromGitHub; };
  cli = buildDunePackage (shared // {
    pname = "cli";

    buildInputs = [
      re
      reason
      reason-native-pastel
    ];
  });
in
  buildDunePackage (shared // {
    pname = "rely";

    buildInputs = [
      reason
    ];

    propagatedBuildInputs = [
      re
      cli
      reason-native-file-context-printer
      reason-native-pastel
    ];

    meta = shared.meta //{
      description = "A Jest-inspired testing framework for native OCaml/Reason";
      downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/rely";
      homepage = "https://reason-native.com/docs/rely/";
    };
  })
