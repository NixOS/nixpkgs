{ lib, stdenv, buildEnv, haskell, nodejs, fetchurl, makeWrapper }:

# To update:
# 1) Update versions in ./update-elm.rb and run it.
# 2) Checkout elm-reactor and run `elm-package install -y` inside.
# 3) Run ./elm2nix.rb in elm-reactor's directory.
# 4) Move the resulting 'package.nix' to 'packages/elm-reactor-elm.nix'.

let
  makeElmStuff = deps:
    let json = builtins.toJSON (lib.mapAttrs (name: info: info.version) deps);
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
                 mkdir -p elm-stuff/packages/${name}
                 ln -s ${pkg} elm-stuff/packages/${name}/${info.version}
               '') deps;
    in ''
      export HOME=/tmp
      mkdir elm-stuff
      cat > elm-stuff/exact-dependencies.json <<EOF
      ${json}
      EOF
    '' + lib.concatStrings cmds;

  hsPkgs = haskell.packages.ghc822.override {
    overrides = self: super:
      let hlib = haskell.lib;
          elmPkgs = {
            elm = hlib.overrideCabal (self.callPackage ./packages/elm.nix { }) {
              preConfigure = "export HOME=`pwd`";
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
