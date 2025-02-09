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

  pkgs = import ../../../../default.nix {};

  sbcl = "${pkgs.sbcl}/bin/sbcl --script";

  bordeaux-threads = import ./bordeaux-threads.nix;

  sbclPackages = { inherit bordeaux-threads; };

  sbclWithPackages = pkgs.lispPackages_new.lispWithPackagesInternal sbclPackages;

  sbcl-bt = sbclWithPackages (p: [ p.bordeaux-threads ]);

in sbcl-bt
