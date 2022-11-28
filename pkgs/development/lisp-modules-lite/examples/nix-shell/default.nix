{ pkgs ? import ../../../../.. {} }:

with pkgs.lispPackagesLite;

lispDerivation {
  src = ./.;
  lispSystem = "dev";
  lispDependencies = [ alexandria ];
  buildInputs = [ pkgs.sbcl ];
}
