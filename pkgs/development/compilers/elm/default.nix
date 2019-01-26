{ lib, stdenv, buildEnv
, haskell, nodejs
, fetchurl, fetchpatch, makeWrapper, git }:

let
  fetchElmDeps = import ./fetchElmDeps.nix { inherit stdenv lib fetchurl; };
  hsPkgs = haskell.packages.ghc863.override {
    overrides = self: super: with haskell.lib;
      let elmPkgs = {
            elm = overrideCabal (self.callPackage ./packages/elm.nix { }) (drv: {
              # sadly with parallelism most of the time breaks compilation
              enableParallelBuilding = false;
              preConfigure = self.fetchElmDeps {
                elmPackages = (import ./packages/elm-srcs.nix);
                versionsDat = ./versions.dat;
              };
              patches = [
                (fetchpatch {
                  url = "https://github.com/elm/compiler/pull/1886/commits/39d86a735e28da514be185d4c3256142c37c2a8a.patch";
                  sha256 = "0nni5qx1523rjz1ja42z6z9pijxvi3fgbw1dhq5qi11mh1nb9ay7";
                })
              ];
              buildTools = drv.buildTools or [] ++ [ makeWrapper ];
              jailbreak = true;
              postInstall = ''
                wrapProgram $out/bin/elm \
                  --prefix PATH ':' ${lib.makeBinPath [ nodejs ]}
              '';
            });

            /*
            The elm-format expression is updated via a script in the https://github.com/avh4/elm-format repo:
            `pacakge/nix/build.sh`
            */
            elm-format = justStaticExecutables (doJailbreak (self.callPackage ./packages/elm-format.nix {}));

            inherit fetchElmDeps;
            elmVersion = elmPkgs.elm.version;
          };
      in elmPkgs // {
        inherit elmPkgs;

        # Needed for elm-format
        indents = self.callPackage ./packages/indents.nix {};
      };
  };
in hsPkgs.elmPkgs
