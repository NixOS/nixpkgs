{ lib, stdenv, buildEnv, haskell, nodejs, fetchurl, fetchpatch, makeWrapper }:

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

  hsPkgs = haskell.packages.ghc7102.override {
    overrides = self: super:
      let hlib = haskell.lib;
          elmRelease = import ./packages/release.nix { inherit (self) callPackage; };
          elmPkgs' = elmRelease.packages;
          elmPkgs = elmPkgs' // {

            elm-reactor = hlib.overrideCabal elmPkgs'.elm-reactor (drv: {
              buildTools = drv.buildTools or [] ++ [ self.elm-make ];
              patches = [ (fetchpatch {
                url = "https://github.com/elm-lang/elm-reactor/commit/ca4d91d3fc7c6f72aa802d79fd1563ab5f3c4f2c.patch";
                sha256 = "0cjcv5rvrq7v1j8n8w87ljgza522cm32cy4n4rq5ysjq3qnaxwcq";
              }) ];
              preConfigure = makeElmStuff (import ./packages/elm-reactor-elm.nix);
            });

            elm-package = hlib.appendPatch elmPkgs'.elm-package (fetchpatch {
              url = "https://github.com/elm-lang/elm-package/commit/af517f2ffe15f8ec1d8c38f01ce188bbdefea47a.patch";
              sha256 = "1l66i4qssp0mcq8yypcn1ps3n2bskyfiqf0qr8gan6wz3znafpy9";
            });

            elm-repl = hlib.overrideCabal elmPkgs'.elm-repl (drv: {
              doCheck = false;
              buildTools = drv.buildTools or [] ++ [ makeWrapper ];
              postInstall =
                let bins = lib.makeSearchPath "bin" [ nodejs self.elm-make ];
                in ''
                  wrapProgram $out/bin/elm-repl \
                    --prefix PATH ':' ${bins}
                '';
            });

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
