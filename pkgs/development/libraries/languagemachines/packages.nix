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
  mbt = pkgs.mbt;
  frog = pkgs.frog;
  frogdata = pkgs.frogdata;

  test = pkgs.frog.tests.simple;
}
