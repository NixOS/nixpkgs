{ lib, stdenv, buildEnv, haskell, nodejs, fetchurl, fetchpatch, makeWrapper }:

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

  hsPkgs = haskell.packages.ghc801.override {
    overrides = self: super:
      let hlib = haskell.lib;
          elmRelease = import ./packages/release.nix { inherit (self) callPackage; };
          elmPkgs' = elmRelease.packages;
          elmPkgs = elmPkgs' // {

            elm-reactor = hlib.overrideCabal elmPkgs'.elm-reactor (drv: {
              buildTools = drv.buildTools or [] ++ [ self.elm-make ];
              preConfigure = makeElmStuff (import ./packages/elm-reactor-elm.nix);
            });

            elm-repl = hlib.overrideCabal elmPkgs'.elm-repl (drv: {
              doCheck = false;
              buildTools = drv.buildTools or [] ++ [ makeWrapper ];
              postInstall =
                let bins = lib.makeBinPath [ nodejs self.elm-make ];
                in ''
                  wrapProgram $out/bin/elm-repl \
                    --prefix PATH ':' ${bins}
                '';
            });

            /*
            This is not a core Elm package, and it's hosted on GitHub.
            To update, run:

                cabal2nix --jailbreak --revision refs/tags/foo http://github.com/avh4/elm-format > packages/elm-format.nix

            where foo is a tag for a new version, for example "0.3.1-alpha".
            */
            elm-format = self.callPackage ./packages/elm-format.nix { };

          };
      in elmPkgs // {
        inherit elmPkgs;
        elmVersion = elmRelease.version;
      };
  };
in hsPkgs.elmPkgs // {
  elm = buildEnv {
    name = "elm-${hsPkgs.elmVersion}";
    paths = lib.mapAttrsToList (name: pkg: pkg) hsPkgs.elmPkgs;
    pathsToLink = [ "/bin" ];
  };
}
