{ lib, fetchFromGitHub, buildDunePackage, qcheck-core, reason, reason-native-console,   reason-native-rely, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "qcheck-rely";

  buildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    qcheck-core
    reason-native-console
    reason-native-rely
  ];

  meta = shared.meta // {
    description = "A library containing custom Rely matchers allowing for easily using QCheck with Rely. QCheck is a 'QuickCheck inspired property-based testing for OCaml, and combinators to generate random values to run tests on'";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/qcheck-rely";
  };
})
