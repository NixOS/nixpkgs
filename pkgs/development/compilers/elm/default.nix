{ lib, stdenv, buildEnv
, haskell, nodejs
, fetchurl, fetchpatch, makeWrapper, git }:

# To update:

# 1) Modify ./update.sh and run it

# 2) to generate versions.dat:
# 2.1) git clone https://github.com/elm/compiler.git
# 2.2) cd compiler
# 2.3) cabal2nix --shell . | sed 's/"default",/"ghc822",/' > shell.nix
# 2.4) nix-shell
# 2.5) mkdir .elm
# 2.6) export ELM_HOME=$(pwd)/.elm
# 2.7) cabal build
# 2.8) cp .elm/0.19.0/package/versions.dat ...

# 3) generate a template for elm-elm.nix with:
# (
#   echo "{";
#   jq '.dependencies | .direct, .indirect | to_entries | .[] | { (.key) : { version : .value, sha256:  "" } } ' \
#   < ui/browser/elm.json \
#   | sed 's/:/ =/' \
#   | sed 's/^[{}]//' \
#   | sed -E 's/(["}]),?$/\1;/' \
#   | sed -E 's/"(version|sha256)"/\1/' \
#   | grep -v '^$';
#   echo "}"
# )
#
# ... then fill in the sha256s

# Notes:

# the elm binary embeds a piece of pre-compiled elm code, used by 'elm
# reactor'. this means that the build process for 'elm' effectively
# executes 'elm make'. that in turn expects to retrieve the elm
# dependencies of that code (elm/core, etc.) from
# package.elm-lang.org, as well as a cached bit of metadata
# (versions.dat).

# the makeDotElm function lets us retrieve these dependencies in the
# standard nix way. we have to copy them in (rather than symlink) and
# make them writable because the elm compiler writes other .dat files
# alongside the source code. versions.dat was produced during an
# impure build of this same code; the build complains that it can't
# update this cache, but continues past that warning.

# finally, we set ELM_HOME to point to these pre-fetched artifacts so
# that the default of ~/.elm isn't used.

let
  fetchElmDeps = import ./fetchElmDeps.nix { inherit stdenv lib fetchurl; };
  hsPkgs = haskell.packages.ghc822.override {
    overrides = self: super: with haskell.lib;
      let elmPkgs = {
            elm = overrideCabal (self.callPackage ./packages/elm.nix { }) (drv: {
              # sadly with parallelism most of the time breaks compilation
              enableParallelBuilding = false;
              preConfigure = fetchElmDeps {
                elmPackages = (import ./packages/elm-elm.nix);
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
