{ lib, stdenv, pkgs
, haskell, nodejs
, fetchurl, fetchpatch, makeWrapper, writeScriptBin }:
let
  fetchElmDeps = import ./fetchElmDeps.nix { inherit stdenv lib fetchurl; };

  hsPkgs = haskell.packages.ghc881.override {
    overrides = self: super: with haskell.lib;
      let elmPkgs = rec {
            elm = overrideCabal (self.callPackage ./packages/elm.nix { }) (drv: {
              # sadly with parallelism most of the time breaks compilation
              enableParallelBuilding = false;
              preConfigure = self.fetchElmDeps {
                elmPackages = (import ./packages/elm-srcs.nix);
                elmVersion = drv.version;
                registryDat = ./registry.dat;
              };
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
            elm-format = justStaticExecutables (overrideCabal (self.callPackage ./packages/elm-format.nix {}) (drv: {
              # GHC 8.8.1 support
              # https://github.com/avh4/elm-format/pull/640
              patches = [(
                fetchpatch {
                  url = "https://github.com/turboMaCk/elm-format/commit/4f4abdc7117ed6ce3335f6cf39b6495b48067b7c.patch";
                  sha256 = "1zqk6q6w0ph12mnwffgwzf4h1hcgqg0v09ws9q2g5bg2riq4rvd9";
                }
              )];
              # Tests are failing after upgrade to ghc881.
              # Cause is probably just a minor change in stdout output
              # see https://github.com/avh4/elm-format/pull/640
              doCheck = false;
              jailbreak = true;
            }));
            elmi-to-json = justStaticExecutables (overrideCabal (self.callPackage ./packages/elmi-to-json.nix {}) (drv: {
              prePatch = ''
                substituteInPlace package.yaml --replace "- -Werror" ""
                hpack
              '';
              jailbreak = true;
            }));

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

      inherit (nodePkgs) elm-doc-preview elm-live elm-upgrade elm-xref elm-analyse;
    };

  patchBinwrap = import ./packages/patch-binwrap.nix { inherit lib writeScriptBin stdenv; };

in hsPkgs.elmPkgs // elmNodePackages // {
  lib = { inherit patchBinwrap; };
}
