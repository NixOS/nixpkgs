{ lib, stdenv, buildEnv
, haskell, nodejs
, fetchurl, fetchpatch, makeWrapper, git }:

let
  fetchElmDeps = import ./fetchElmDeps.nix { inherit stdenv lib fetchurl; };
  hsPkgs = haskell.packages.ghc822.override {
    overrides = self: super: with haskell.lib;
      let elmPkgs = {
            elm = overrideCabal (self.callPackage ./packages/elm.nix { }) (drv: {
              # sadly with parallelism most of the time breaks compilation
              enableParallelBuilding = false;
              preConfigure = self.fetchElmDeps {
                elmPackages = (import ./packages/elm-srcs.nix);
                versionsDat = ./versions.dat;
              };
              buildTools = drv.buildTools or [] ++ [ makeWrapper ];
              patches = [
                (fetchpatch {
                  url = "https://github.com/elm/compiler/pull/1784/commits/78d2d8eab310552b1b877a3e90e1e57e7a09ddec.patch";
                  sha256 = "0vdhk16xqm2hxw12s1b91a0bmi8w4wsxc086qlzglgnjxrl5b3w4";
                })
              ];
              postInstall = ''
                wrapProgram $out/bin/elm \
                  --prefix PATH ':' ${lib.makeBinPath [ nodejs ]}
              '';
            });

            /*
            The elm-format expression is updated via a script in the https://github.com/avh4/elm-format repo:
            `pacakge/nix/build.sh`
            */
            elm-format = self.callPackage ./packages/elm-format.nix {};
            inherit fetchElmDeps;
          };
      in elmPkgs // {
        inherit elmPkgs;
        elmVersion = elmPkgs.elm.version;

        # Needed for elm-format
        indents = self.callPackage ./packages/indents.nix {};
        tasty-quickcheck = self.callPackage ./packages/tasty-quickcheck.nix {};
      };
  };
in hsPkgs.elmPkgs
