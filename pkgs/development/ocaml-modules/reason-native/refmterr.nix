{ lib, fetchFromGitHub, buildDunePackage, atdgen, re, reason, reason-native-pastel, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "refmterr";

  buildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    atdgen
    re
    reason-native-pastel
  ];

  meta = shared.meta // {
    description = "An error formatter tool for Reason and OCaml. Takes raw error output from compiler and converts to pretty output";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/refmterr";
    homepage = "https://reason-native.com/docs/refmterr/";
  };
})
