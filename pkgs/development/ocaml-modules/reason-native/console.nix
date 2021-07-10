{ lib, fetchFromGitHub, buildDunePackage, callPackage, reason, reason-native-console, ... }:

let shared = import ./shared.nix { inherit lib fetchFromGitHub; }; in

buildDunePackage (shared // {
  pname = "console";

  buildInputs = [
    reason
  ];

  passthru.tests = {
    console = callPackage ./tests/console {
      inherit buildDunePackage reason reason-native-console;
    };
  };

  meta = shared.meta // {
    description = "A library providing a web-influenced polymorphic console API for native Console.log(anything) with runtime printing";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/console";
    homepage = "https://reason-native.com/docs/console/";
  };
})
