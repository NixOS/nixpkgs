{ lib, stdenv, buildEnv
, haskell, nodejs
, fetchurl, fetchpatch, makeWrapper, git }:

let
  fetchElmDeps = import ./fetchElmDeps.nix { inherit stdenv lib fetchurl; };
  hsPkgs = haskell.packages.ghc864.override {
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
                (fetchpatch {
                  url = "https://github.com/elm/compiler/pull/1850/commits/e3512d887df41a8162c3e361171c04beca08415b.patch";
                  sha256 = "118smw4bzzj0bv124h2dd7vfh5jhddpivw51x572wjcdl165zym7";
                })
                (fetchpatch {
                  url = "https://github.com/elm/compiler/pull/1850/commits/533a1991e26215b9bebb369457cff06842c13a49.patch";
                  sha256 = "09brmdmfqig7qxaa3mdp8qsxwz6jwbn0yszx2rs63nmacbyrwjlr";
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
