{ lib, stdenv, pkgs
, haskell, nodejs
, fetchurl, fetchpatch, makeWrapper, writeScriptBin }:
let
  fetchElmDeps = import ./fetchElmDeps.nix { inherit stdenv lib fetchurl; };

  hsPkgs = haskell.packages.ghc865.override {
    overrides = self: super: with haskell.lib;
      let elmPkgs = rec {
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
            `package/nix/build.sh`
            */
            elm-format = justStaticExecutables (doJailbreak (self.callPackage ./packages/elm-format.nix {}));
            elmi-to-json = justStaticExecutables (self.callPackage ./packages/elmi-to-json.nix {});

            inherit fetchElmDeps;
            elmVersion = elmPkgs.elm.version;
          };
      in elmPkgs // {
        inherit elmPkgs;

        # Needed for elm-format
        indents = self.callPackage ./packages/indents.nix {};
      };
  };

  /*
  Node/NPM based dependecies can be upgraded using script
  `packages/generate-node-packages.sh`.
  Packages which rely on `bin-wrap` will fail by default
  and can be patched using `patchBinwrap` function defined in `packages/patch-binwrap.nix`.
  */
  elmNodePackages =
    let
      nodePkgs = import ./packages/node-composition.nix {
          inherit nodejs pkgs;
          inherit (stdenv.hostPlatform) system;
        };
    in with hsPkgs.elmPkgs; {
      elm-test = patchBinwrap [elmi-to-json] nodePkgs.elm-test;
      elm-verify-examples = patchBinwrap [elmi-to-json] nodePkgs.elm-verify-examples;
      elm-language-server = nodePkgs."@elm-tooling/elm-language-server";

      # elm-analyse@0.16.4 build is not working
      elm-analyse = nodePkgs."elm-analyse-0.16.3";
      inherit (nodePkgs) elm-doc-preview elm-live elm-upgrade elm-xref;
    };

  patchBinwrap = import ./packages/patch-binwrap.nix { inherit lib writeScriptBin stdenv; };

in hsPkgs.elmPkgs // elmNodePackages // {
  lib = { inherit patchBinwrap; };
}
