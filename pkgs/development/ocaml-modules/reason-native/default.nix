{
  lib,
  newScope,
  fetchFromGitHub,
  atdgen,
  buildDunePackage,
  junit,
  ppxlib,
  qcheck-core,
  re,
  reason,
}:

lib.makeScope newScope (self: {
  inherit lib buildDunePackage re reason ppxlib;

  # Upstream doesn't use tags, releases, or branches.
  src = fetchFromGitHub {
    owner = "reasonml";
    repo = "reason-native";
    rev = "20b1997b6451d9715dfdbeec86a9d274c7430ed8";
    hash = "sha256-96Ucq70eSy6pqh5ne9xoODWe/nPuriZnFAdx0OkLVCs=";
  };

  cli = self.callPackage ./cli.nix { };
  console = self.callPackage ./console.nix { };
  dir = self.callPackage ./dir.nix { };
  file-context-printer = self.callPackage ./file-context-printer.nix { };
  frame = self.callPackage ./frame.nix { };
  fp = self.callPackage ./fp.nix { };
  fs = self.callPackage ./fs.nix { };
  pastel = self.callPackage ./pastel.nix { };
  pastel-console = self.callPackage ./pastel-console.nix { };
  qcheck-rely = self.callPackage ./qcheck-rely.nix {
    inherit qcheck-core;
  };
  refmterr = self.callPackage ./refmterr.nix {
    inherit atdgen;
  };
  rely = self.callPackage ./rely.nix { };
  rely-junit-reporter = self.callPackage ./rely-junit-reporter.nix {
    inherit atdgen junit;
  };
  unicode-config = self.callPackage ./unicode-config.nix { };
  unicode = self.callPackage ./unicode.nix { };
  utf8 = self.callPackage ./utf8.nix { };
})
