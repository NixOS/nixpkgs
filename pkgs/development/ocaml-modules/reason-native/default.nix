{ newScope, lib, fetchFromGitHub, callPackage, buildDunePackage, atdgen, junit, qcheck-core, re, reason, reason-native }:

let
  generic = (somePath:
    let
      prepkg = import somePath {
        inherit callPackage cli buildDunePackage atdgen junit qcheck-core re reason;
        inherit (reason-native) console file-context-printer fp pastel rely;
      };
    in
      buildDunePackage
        ({
          version = "2021-16-16-aec0ac6";
          src = fetchFromGitHub {
            owner = "reasonml";
            repo = "reason-native";
            rev = "aec0ac681be7211b4d092262281689c46deb63e1";
            sha256 = "sha256-QoyI50MBY3RJBmM1y90n7oXrLmHe0CQxKojv+7YbegE=";
          };
          useDune2 = true;
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
