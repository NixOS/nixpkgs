{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

# cabal2nix doesn't properly add dependencies conditional on arch(javascript)
self: super: {

  ghcjs-base = lib.pipe super.ghcjs-base [
    dontCheck # <command line>: does not exist: test/compat.js
    (addBuildDepends (
      with self;
      [
        HUnit
        aeson
        attoparsec
        dlist
        hashable
        primitive
        quickcheck-unicode
        scientific
        test-framework
        test-framework-hunit
        test-framework-quickcheck2
        unordered-containers
        vector
      ]
    ))
  ];

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

  # Marked as dontDistribute in -common because of jsaddle-webkit2gtk
  # which requires an unmaintained version of libsoup. Since this dep
  # is unnecessary for the JS backend, we can re-enable these jobs here.
  reflex-dom = doDistribute (
    super.reflex-dom.override (drv: {
      jsaddle-webkit2gtk = null;
    })
  );
  reflex-localize-dom = doDistribute super.reflex-localize-dom;
  trasa-reflex = doDistribute super.trasa-reflex;

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

  # Tests are extremely slow
  scientific = dontCheck super.scientific;

  # Tests hang
  logict = dontCheck super.logict;

  # error: no C compiler provided for this platform
  servant-lucid = dontCheck super.servant-lucid;

  # javascript-unknown-ghcjs-ghc-9.12.2: could not execute: hspec-discover
  http-types = dontCheck super.http-types;

  # *** Failed! Exception: 'createPipeInternal: unsupported operation (Operation is not supported)' (after 1 test):
  QuickCheck = dontCheck super.QuickCheck;

  # SyntaxError: Invalid or unexpected token
  syb = dontCheck super.syb;

  # uncaught exception in Haskell thread: ReferenceError: h$XXH3_64bits_withSeed is not defined
  hashable = dontCheck super.hashable;

  # uncaught exception in Haskell thread: ReferenceError: h$hs_text_short_is_valid_utf8 is not defined
  text-short = dontCheck super.text-short;

  # uncaught exception in Haskell main thread: ReferenceError: h$clock_getres is not defined
  time-compat = dontCheck super.time-compat;

  # uncaught exception in Haskell main thread: ReferenceError: h$getNumberOfProcessors is not defined
  hedgehog = dontCheck super.hedgehog;

  # uncaught exception in Haskell main thread: ReferenceError: h$readlink is not defined
  adjunctions = dontCheck super.adjunctions;
  aeson-gadt-th = dontCheck super.aeson-gadt-th;
  aeson-qq = dontCheck super.aeson-qq;
  base-orphans = dontCheck super.base-orphans;
  bifunctors = dontCheck super.bifunctors;
  constraints = dontCheck super.constraints;
  distributive = dontCheck super.distributive;
  doctest = dontCheck super.doctest;
  generic-deriving = dontCheck super.generic-deriving;
  hspec-discover = dontCheck super.hspec-discover;
  hspec-hedgehog = dontCheck super.hspec-hedgehog;
  http-api-data = dontCheck super.http-api-data;
  invariant = dontCheck super.invariant;
  lucid = dontCheck super.lucid;
  markdown-unlit = dontCheck super.markdown-unlit;
  newtype-generics = dontCheck super.newtype-generics;
  records-sop = dontCheck super.records-sop;
  reflection = dontCheck super.reflection;
  reflex = dontCheck super.reflex;
  resourcet = dontCheck super.resourcet;
  safe-exceptions = dontCheck super.safe-exceptions;
  servant = dontCheck super.servant;
  should-not-typecheck = dontCheck super.should-not-typecheck;
  stringbuilder = dontCheck super.stringbuilder;
  th-compat = dontCheck super.th-compat;
  th-orphans = dontCheck super.th-orphans;
  zenc = dontCheck super.zenc;
}
