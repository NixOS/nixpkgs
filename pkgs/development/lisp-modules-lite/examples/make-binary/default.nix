{ pkgs ? import ../../../../.. {} }:

with pkgs.lispPackagesLite;
lispDerivation {
  # Added a bunch of unnecessary deps to see how this system handles
  # deduplication
  lispDependencies = [ alexandria arrow-macros cl-async cl-async-ssl ];
  lispSystem = "demo";
  version = "0.0.1";
  src = pkgs.lib.cleanSource ./.;
  # Binary is automatically built using ASDF’s :build-operation "program-op"
  installPhase = ''
    mkdir -p "$out/bin"
    cp dist/demo "$out/bin/"
  '';
}
