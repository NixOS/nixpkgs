{
  description = "Demo lispPackagesLite app using flakes";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    hly-nixpkgs.url = "github:hraban/nixpkgs/feat/lisp-packages-lite";
    # This is how you would override a package or include a new one
    asdf-src = {
      url = "git+https://gitlab.common-lisp.net/asdf/asdf";
      flake = false;
    };
  };
  outputs = {
    self, nixpkgs, asdf-src, hly-nixpkgs, flake-utils
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs.callPackage hly-nixpkgs {}) lispPackagesLite;
      in
      with lispPackagesLite;
      let
        # Create a new lisp dependency on the fly from source. Note: this is not
        # the same as overridePackage - for overriding a deeper dependency to
        # automatically be picked up by other dependencies, make sure to see
        # that example. This is just for adding an entirely new dependency.
        asdf = lispDerivation { src = asdf-src; lispSystem = "asdf"; };
      in
        {
          packages = {
            default = lispDerivation {
              lispSystem = "demo";
              lispDependencies = [
                # This is our own copy of asdf
                asdf
                # This came from the with lispPackagesLite scope
                alexandria
                arrow-macros
              ];
              src = pkgs.lib.cleanSource ./.;
              meta = {
                license = "AGPLv3";
              };
            };
          };
        });
  }
