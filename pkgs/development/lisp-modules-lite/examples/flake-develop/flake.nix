{
  description = "Nix develop shell using lispPackagesLite";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    hly-nixpkgs.url = "github:hraban/nixpkgs/feat/lisp-packages-lite";
  };
  outputs = {
    self, nixpkgs, hly-nixpkgs, flake-utils
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs.callPackage hly-nixpkgs {}) lispPackagesLite;
      in
      with lispPackagesLite;
      {
        devShells = {
          default = lispDerivation {
            src = ./.;
            lispSystem = "dev";
            lispDependencies = [ alexandria ];
            buildInputs = [ pkgs.sbcl ];
          };
        };
      });
  }
