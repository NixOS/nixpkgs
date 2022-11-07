# To run this example from the command line, run this command:
#  $ nix-build ./sbcl-with-bt.nix
#  $ ls ./result/
#
# To run from a nix repl, run:
#  $ nix repl
#  nix-repl> sbcl-bt = import ./sbcl-with-bt.nix
#  nix-repl> :b sbcl-bt
#
# In the `result/bin` directory you can find an `sbcl` executable
# that, when started, is able to load the pre-compiled
# bordeaux-threads from the Nix store:
#  $ ./result/bin/sbcl
#  * (require :asdf)
#  * (asdf:load-system :bordeaux-threads)

let

  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/21.11.tar.gz";
    sha256 = "162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
  }) {};

  sbcl = "${pkgs.sbcl}/bin/sbcl --script";

  nix-cl = import ../. {};

  bordeaux-threads = import ./bordeaux-threads.nix;

  sbclPackages = { inherit bordeaux-threads; };

  sbclWithPackages = nix-cl.lispWithPackagesInternal sbclPackages;

  sbcl-bt = sbclWithPackages (p: [ p.bordeaux-threads ]);

in sbcl-bt
