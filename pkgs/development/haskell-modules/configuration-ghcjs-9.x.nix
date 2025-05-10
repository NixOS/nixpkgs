{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

# cabal2nix doesn't properly add dependencies conditional on arch(javascript)

(self: super: {
  ghcjs-base = addBuildDepends (with self; [
    aeson
    attoparsec
    dlist
    hashable
    primitive
    scientific
    unordered-containers
    vector
  ]) super.ghcjs-base;

  ghcjs-dom = addBuildDepend self.ghcjs-dom-javascript super.ghcjs-dom;
  ghcjs-dom-javascript = addBuildDepend self.ghcjs-base super.ghcjs-dom-javascript;
  jsaddle = addBuildDepend self.ghcjs-base super.jsaddle;
  jsaddle-dom = addBuildDepend self.ghcjs-base super.jsaddle-dom;
  jsaddle-warp = overrideCabal (drv: {
    libraryHaskellDepends = [ ];
    testHaskellDepends = [ ];
  }) super.jsaddle-warp;

  entropy = addBuildDepend self.ghcjs-dom super.entropy;

  # https://gitlab.haskell.org/ghc/ghc/-/issues/25083#note_578275
  patch = haskellLib.disableParallelBuilding super.patch;
  reflex-dom-core = haskellLib.disableParallelBuilding super.reflex-dom-core;

  reflex-dom =
    lib.warn "reflex-dom builds with JS backend but it is missing fixes for working at runtime"
      super.reflex-dom.override
      (drv: {
        jsaddle-webkit2gtk = null;
      });

  miso-examples = pkgs.lib.pipe super.miso-examples [
    (addBuildDepends (
      with self;
      [
        aeson
        ghcjs-base
        jsaddle-warp
        miso
        servant
      ]
    ))
  ];

  # https://github.com/haskellari/splitmix/pull/75
  splitmix = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/haskellari/splitmix/commit/7ffb3158f577c48ab5de774abea47767921ef3e9.patch";
    sha256 = "sha256-n2q4FGf/pPcI1bhb9srHjHLzaNVehkdN6kQgL0F4MMg=";
  }) super.splitmix;

  # See https://gitlab.haskell.org/ghc/ghc/-/issues/26019#note_621324, without this flag the build OOMs
  SHA = haskellLib.appendConfigureFlag "--ghc-option=-fignore-interface-pragmas" super.SHA;
})
