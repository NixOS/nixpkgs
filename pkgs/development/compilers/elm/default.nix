{ lib, stdenv, buildEnv, haskell, nodejs, fetchurl, makeWrapper }:

# To update:
# 1) Update versions in ./update-elm.rb and run it.
# 2) Checkout elm-reactor and run `elm-package install -y` inside.
# 3) Run ./elm2nix.rb in elm-reactor's directory.
# 4) Move the resulting 'package.nix' to 'packages/elm-reactor-elm.nix'.

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
  makeDotElm = ver: deps:
    let versionsDat = ./versions.dat;
        cmds = lib.mapAttrsToList (name: info: let
                 pkg = stdenv.mkDerivation {

                   name = lib.replaceChars ["/"] ["-"] name + "-${info.version}";

                   src = fetchurl {
                     url = "https://github.com/${name}/archive/${info.version}.tar.gz";
                     meta.homepage = "https://github.com/${name}/";
                     inherit (info) sha256;
                   };

                   phases = [ "unpackPhase" "installPhase" ];

                   installPhase = ''
                     mkdir -p $out
                     cp -r * $out
                   '';

                 };
               in ''
                 mkdir -p .elm/${ver}/package/${name}
                 cp -R ${pkg} .elm/${ver}/package/${name}/${info.version}
                 chmod -R +w .elm/${ver}/package/${name}/${info.version}
               '') deps;
    in ''
      mkdir -p .elm/${ver}/package;
      ln -s ${versionsDat} .elm/${ver}/package/versions.dat;
    '' + lib.concatStrings cmds;

  hsPkgs = haskell.packages.ghc822.override {
    overrides = self: super:
      let hlib = haskell.lib;
          elmPkgs = {
            elm = hlib.overrideCabal (self.callPackage ./packages/elm.nix { }) {
              preConfigure = ''
                export ELM_HOME=`pwd`/.elm
              '' + (makeDotElm "0.19.0" (import ./packages/elm-elm.nix));
            };

            /*
            This is not a core Elm package, and it's hosted on GitHub.
            To update, run:

                cabal2nix --jailbreak --revision refs/tags/foo http://github.com/avh4/elm-format > packages/elm-format.nix

            where foo is a tag for a new version, for example "0.3.1-alpha".
            */
            elm-format = self.callPackage ./packages/elm-format.nix { };
            elm-interface-to-json = self.callPackage ./packages/elm-interface-to-json.nix {};
          };
      in elmPkgs // {
        inherit elmPkgs;
        elmVersion = elmPkgs.elm.version;
      };
  };
in hsPkgs.elmPkgs
