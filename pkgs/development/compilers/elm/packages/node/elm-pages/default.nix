{
  nodePkgs,
  pkgs,
  lib,
  makeWrapper,
}:

let
  ESBUILD_BINARY_PATH = lib.getExe (
    pkgs.esbuild.override {
      buildGoModule =
        args:
        pkgs.buildGoModule (
          args
          // rec {
            version = "0.21.5";
            src = pkgs.fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    }
  );
in
nodePkgs."elm-pages".overrideAttrs (old: {
  inherit ESBUILD_BINARY_PATH;
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    makeWrapper
    old.nodejs.pkgs.node-gyp-build
  ];

  preRebuild = ''
    sed -i 's/"esbuild": "0\.19\.12"/"esbuild": "0.21.5"/' package.json
  '';

  # can't use `patches = [ <patch_file> ]` with a nodePkgs derivation;
  # need to patch in one of the build phases instead.
  # see upstream issue https://github.com/dillonkearns/elm-pages/issues/305 for dealing with the read-only problem
  preFixup = ''
    patch $out/lib/node_modules/elm-pages/generator/src/codegen.js ${./fix-read-only.patch}
    patch $out/lib/node_modules/elm-pages/generator/src/init.js ${./fix-init-read-only.patch}
  '';

  postFixup = ''
    wrapProgram $out/bin/elm-pages --prefix PATH : ${
      with pkgs.elmPackages;
      lib.makeBinPath [
        elm
        elm-review
        elm-optimize-level-2
      ]
    }
  '';

  meta =
    with lib;
    nodePkgs."elm-pages".meta
    // {
      description = "Statically typed site generator for Elm";
      homepage = "https://github.com/dillonkearns/elm-pages";
      license = licenses.bsd3;
      maintainers = [
        maintainers.turbomack
        maintainers.jali-clarke
      ];
    };
})
