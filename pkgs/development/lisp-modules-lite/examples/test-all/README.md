# Test all lispPackagesLite packages

To test all packages (this should succeed):

    $ nix-build

To test only one package, e.g. alexandria:

    $ nix-build -A alexandria

To test all packages, even ones marked as explicitly failing (this will fail):

    $ nix-build -E 'import ./. { skip = []; }'

To test all packages with a non-default Lisp:

    $ nix-build -E '
        let
          pkgs = (import ../../../../.. {});
          lispPackagesLite = pkgs.lispPackagesLite.override {
            lisp = pkgs.ecl;
          };
        in
          (import ./. { inherit lispPackagesLite; } )'
