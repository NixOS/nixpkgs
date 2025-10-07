{ pkgs }:
let
  inherit (pkgs) callPackage;
  icu = pkgs.icu60;
in
{
  ticcutils = pkgs.ticcutils;
  libfolia = pkgs.libfolia;
  ucto = callPackage ./ucto.nix { inherit icu; };
  uctodata = pkgs.uctodata;
  timbl = callPackage ./timbl.nix { };
  timblserver = callPackage ./timblserver.nix { };
  mbt = callPackage ./mbt.nix { };
  frog = callPackage ./frog.nix { inherit icu; };
  frogdata = callPackage ./frogdata.nix { };

  test = callPackage ./test.nix { };
}
