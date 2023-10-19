{ newScope, lib, fetchFromGitHub, callPackage, buildDunePackage, atdgen, junit, qcheck-core, re, reason, reason-native, fetchpatch }:

let
  generic = (somePath:
    let
      prepkg = import somePath {
        inherit callPackage cli buildDunePackage atdgen junit qcheck-core re reason fetchpatch;
        inherit (reason-native) console file-context-printer fp pastel rely;
      };
    in
      buildDunePackage
        ({
          version = "2022-08-31-a0ddab6";
          src = fetchFromGitHub {
            owner = "reasonml";
            repo = "reason-native";
            rev = "a0ddab6ab25237961e32d8732b0a222ec2372d4a";
            hash = "sha256-s2N5OFTwIbKXcv05gQRaBMCHO1Mj563yhryPeo8jMh8=";
          };
          duneVersion = "3";
          meta = with lib; {
            description = "Libraries for building and testing native Reason programs";
            downloadPage = "https://github.com/reasonml/reason-native";
            homepage = "https://reason-native.com/";
            license = licenses.mit;
            maintainers = with maintainers; [ ];
          } // (prepkg.meta or {});
        } // prepkg)
  );
  cli = generic ./cli.nix; # Used only by Rely.
in
  lib.makeScope newScope (self: with self; {
    console = generic ./console.nix;
    dir = generic ./dir.nix;
    file-context-printer = generic ./file-context-printer.nix;
    fp = generic ./fp.nix;
    pastel = generic ./pastel.nix;
    pastel-console = generic ./pastel-console.nix;
    qcheck-rely = generic ./qcheck-rely.nix;
    refmterr = generic ./refmterr.nix;
    rely = generic ./rely.nix;
    rely-junit-reporter = generic ./rely-junit-reporter.nix;
  })
