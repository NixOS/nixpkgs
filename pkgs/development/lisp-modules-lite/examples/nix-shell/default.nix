{ pkgs ? import ../../../../.. {} }:

with pkgs.lispPackagesLite;

lispDerivation {
  src = pkgs.lib.cleanSource ./.;
  lispSystem = "dev";
  lispDependencies = [ arrow-macros ];
  buildInputs = [ pkgs.sbcl ];
}
