{

  description = "Utilities for packaging ASDF Common Lisp systems";

  inputs.nixpkgs.url = "nixpkgs";
  inputs.dev.url = "github:uthar/dev";

  outputs = { self, nixpkgs, dev }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      clasp = dev.outputs.packages.x86_64-linux.clasp;
    in
    {
      lib = pkgs.callPackage (import ./. { claspPkg = clasp; }) {};
      devShells.x86_64-linux.default = pkgs.callPackage ./shell.nix {};
    };

}
