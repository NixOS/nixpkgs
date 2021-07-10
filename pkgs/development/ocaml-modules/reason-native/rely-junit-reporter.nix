{ lib, fetchFromGitHub, buildDunePackage, atdgen, junit, re, reason, reason-native-pastel, reason-native-rely, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "rely-junit-reporter";

  buildInputs = [
    atdgen
    reason
  ];

  propagatedBuildInputs = [
    junit
    re
    reason-native-pastel
    reason-native-rely
  ];

  meta = shared.meta //{
    description = "A tool providing JUnit Reporter for Rely Testing Framework";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/rely-junit-reporter";
    homepage = "https://reason-native.com/docs/rely/";
  };
})
