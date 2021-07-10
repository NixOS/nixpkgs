{ lib, fetchFromGitHub, buildDunePackage, reason, re, reason-native-pastel, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "file-context-printer";

  buildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    re
    reason-native-pastel
  ];

  meta = shared.meta //{
    description = "Utility for displaying snippets of files on the command line";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/file-context-printer";
    homepage = "https://reason-native.com/docs/file-context-printer/";
  };
})
