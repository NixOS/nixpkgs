# To run this example from a nix repl, run:
#  $ nix repl
#  nix-repl> abcl-packages = import ./abcl-package-set.nix
#  nix-repl> builtins.attrNames abcl-packages
#  nix-repl> builtins.length (builtins.attrNames abcl-packages)
#
# The import returns a package set, which you can use for example to
# discover what packages are available in lispWithPackages:
#
#  nix-repl> abcl-packages.cl-op<TAB>
#  nix-repl> abcl-packages.cl-opengl
#  nix-repl> # cool, we can use cl-opengl
#  nix-repl> # some-abcl-with-packages (p: [ p.cl-opengl ])


let

  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/21.11.tar.gz";
    sha256 = "162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
  }) {};

  abcl = "${pkgs.abcl}/bin/abcl --batch --load";

  nix-cl = import ../. {};

  abcl-packages = nix-cl.lispPackagesFor abcl;

in abcl-packages
