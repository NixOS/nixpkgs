# To run this example from the command line, run this command:
#
# $ nix-build ./bordeaux-threads.nix
# $ ls ./result/
#
# To run from a nix repl, run:
# $ nix repl
# nix-repl> bt = import ./bordeaux-threads.nix
# nix-repl> :b bt
#
# In the `result` directory you can find .fasl files of the
# bordeaux-threads library:
#
#  $ ls -l ./result/src/

let

  pkgs = import ../../../../default.nix {};

  sbcl = "${pkgs.sbcl}/bin/sbcl --script";

  alexandria = pkgs.lispPackages_new.build-asdf-system {
    pname = "alexandria";
    version = "v1.4";
    src = pkgs.fetchzip {
      url = "https://gitlab.common-lisp.net/alexandria/alexandria/-/archive/v1.4/alexandria-v1.4.tar.gz";
      sha256 = "0r1adhvf98h0104vq14q7y99h0hsa8wqwqw92h7ghrjxmsvz2z6l";
    };
    lisp = sbcl;
  };

  bordeaux-threads = pkgs.lispPackages_new.build-asdf-system {
    pname = "bordeaux-threads";
    version = "0.8.8";
    src = pkgs.fetchzip {
      url = "http://github.com/sionescu/bordeaux-threads/archive/v0.8.8.tar.gz";
      sha256 = "19i443fz3488v1pbbr9x24y8h8vlyhny9vj6c9jk5prm702awrp6";
    };
    lisp = sbcl;
    lispLibs = [ alexandria ];
  };

in bordeaux-threads
