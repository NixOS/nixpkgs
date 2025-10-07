{ pkgs }:
let
  inherit (pkgs) callPackage;
  icu = pkgs.icu60;
in
{
  ticcutils = pkgs.ticcutils;
  libfolia = pkgs.libfolia;
  ucto = pkgs.ucto;
  uctodata = pkgs.uctodata;
  timbl = pkgs.timbl;
  timblserver = pkgs.timblserver;
  mbt = callPackage ./mbt.nix { };
  frog = callPackage ./frog.nix { inherit icu; };
  frogdata = callPackage ./frogdata.nix { };

  test = callPackage ./test.nix { };
}
