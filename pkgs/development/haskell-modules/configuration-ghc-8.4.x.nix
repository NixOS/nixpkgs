{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Use the latest LLVM.
  inherit (pkgs) llvmPackages;

  # Disable GHC 8.4.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  ## Shadowed:

  ## Needs bump to a versioned attribute
  ## Issue: https://github.com/sol/doctest/issues/189
  doctest = overrideCabal super.doctest_0_15_0 (drv: {
    ## Setup: Encountered missing dependencies:
    ## ghc >=7.0 && <8.4
    ##
    ## Setup: Encountered missing dependencies:
    ## QuickCheck >=2.11.3
    doCheck         = false;
  });

  ## Needs bump to a versioned attribute
  ## Setup: Encountered missing dependencies:
  ## Cabal <2.2
  ## Older versions don't compile.
  hackage-db = super.hackage-db_2_0_1;

  ## Needs bump to a versioned attribute
  haddock-library = overrideCabal super.haddock-library_1_5_0_1 (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    ## Older versions don't compile
    ##
    ## Setup: Encountered missing dependencies:
    ## QuickCheck ==2.11.*
    doCheck         = false;
    ## Running Haddock on library for haddock-library-1.5.0.1..
    ## Setup: internal error when calculating transitive package dependencies.
    ## Debug info: []
    doHaddock       = false;
  });

  ## On Hackage:

  ## Upstreamed, awaiting a Hackage release
  http-api-data = overrideCabal super.http-api-data (drv: {
    ##     • No instance for (Semigroup Form)
    ##         arising from the 'deriving' clause of a data type declaration
    ##       Possible fix:
    src = pkgs.fetchFromGitHub {
      owner  = "fizruk";
      repo   = "http-api-data";
      rev    = "83aac9540f4a304927c601c5db12f4dc2bf93816";
      sha256 = "14hy13szr09vsisxi25a4qfajqjwznvn222bqk55dcdlnrgf0zi9";
    };
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11
    jailbreak       = true;
  });

  ## Upstreamed, awaiting a Hackage release
  lambdacube-compiler = overrideCabal super.lambdacube-compiler (drv: {
    ## Setup: Encountered missing dependencies:
    ## aeson >=0.9 && <0.12,
    ## base >=4.7 && <4.10,
    ## directory ==1.2.*,
    ## megaparsec ==5.0.*,
    ## vector ==0.11.*
    src = pkgs.fetchFromGitHub {
      owner  = "lambdacube3d";
      repo   = "lambdacube-compiler";
      rev    = "ff6e3b136eede172f20ea8a0f7017ad1ecd029b8";
      sha256 = "0srzrq5s7pdbygn7vdipxl12a3gbyb6bpa7frbh8zwhb9fz0jx5m";
    };
  });

  ## Upstreamed, awaiting a Hackage release
  lambdacube-ir = overrideCabal super.lambdacube-ir (drv: {
    ## Setup: Encountered missing dependencies:
    ## aeson >=0.9 && <0.12, base >=4.8 && <4.10, vector ==0.11.*
    src = pkgs.fetchFromGitHub {
      owner  = "lambdacube3d";
      repo   = "lambdacube-ir";
      rev    = "b86318b510ef59606c5b7c882cad33af52ce257c";
      sha256 = "0j4r6b32lcm6jg653xzg9ijxkfjahlb4x026mv5dhs18kvgqhr8x";
    };
    prePatch        = "cd lambdacube-ir.haskell; ";
  });

  singletons = super.singletons_2_4_1;
  th-desugar = super.th-desugar_1_8;

  ## Upstreamed, awaiting a Hackage release
  websockets = overrideCabal super.websockets (drv: {
    ##     • No instance for (Semigroup SizeLimit)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid SizeLimit’
    src = pkgs.fetchFromGitHub {
      owner  = "jaspervdj";
      repo   = "websockets";
      rev    = "11ba6d15cf47bace1936b13a58192e37908b0300";
      sha256 = "1swphhnqvs5kh0wlqpjjgx9q91yxi6lasid8akdxp3gqll5ii2hf";
    };
  });


  ## Unmerged

  ## Unmerged.  PR: https://github.com/wrengr/bytestring-trie/pull/3
  bytestring-trie = overrideCabal super.bytestring-trie (drv: {
    ##     • Could not deduce (Semigroup (Trie a))
    ##         arising from the superclasses of an instance declaration
    ##       from the context: Monoid a
    src = pkgs.fetchFromGitHub {
      owner  = "RyanGlScott";
      repo   = "bytestring-trie";
      rev    = "e0ae0cb1ad40dedd560090d69cc36f9760797e29";
      sha256 = "1jkdchvrca7dgpij5k4h1dy4qr1rli3fzbsqajwxmx9865rgiksl";
    };
    ## Setup: Encountered missing dependencies:
    ## HUnit >=1.3.1.1 && <1.7,
    ## QuickCheck >=2.4.1 && <2.11,
    ## lazysmallcheck ==0.6.*,
    ## smallcheck >=1.1.1 && <1.2
    doCheck         = false;
    ## Setup: Encountered missing dependencies:
    ## data-or ==1.0.*
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ (with self; [ data-or ]);
  });

  ## Unmerged.  PR: https://github.com/hanshoglund/monadplus/pull/3
  monadplus = overrideCabal super.monadplus (drv: {
    ##     • No instance for (Semigroup (Partial a b))
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid (Partial a b)’
    src = pkgs.fetchFromGitHub {
      owner  = "asr";
      repo   = "monadplus";
      rev    = "aa09f2473e2c906f2707b8a3fdb0a087405fd6fb";
      sha256 = "0g37s3rih4i3vrn4kjwj12nq5lkpckmjw33xviva9gly2vg6p3xc";
    };
  });

  ## Unmerged.  PR: https://github.com/reflex-frp/reflex/pull/158
  reflex = overrideCabal super.reflex (drv: {
    ##     • Could not deduce (Semigroup (Event t a))
    ##         arising from the superclasses of an instance declaration
    ##       from the context: (Semigroup a, Reflex t)
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "reflex";
      rev    = "4fb50139db45a37493b91973eeaad9885b4c63ca";
      sha256 = "0i7pp6cw394m2vbwcqv9z5ngdarp01sabqr1jkkgchxdkkii94nx";
    };
    ## haddock: internal error: internal: extractDecl (ClsInstD)
    ## CallStack (from HasCallStack):
    ##   error, called at utils/haddock/haddock-api/src/Haddock/Interface/Create.hs:1067:16 in main:Haddock.Interface.Create
    doHaddock       = false;
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11, bifunctors >=5.2 && <5.5
    jailbreak       = true;
    ## Setup: Encountered missing dependencies:
    ## data-default -any,
    ## lens -any,
    ## monad-control -any,
    ## prim-uniq -any,
    ## reflection -any,
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ (with self; [ data-default haskell-src-exts lens monad-control prim-uniq reflection split template-haskell unbounded-delays ]);
  });

  ## Unmerged.  PR: https://github.com/bos/text-format/pull/21
  text-format = overrideCabal super.text-format (drv: {
    ##     • No instance for (Semigroup Format)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Format’
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "text-format";
      rev    = "a1cda87c222d422816f956c7272e752ea12dbe19";
      sha256 = "0lyrx4l57v15rvazrmw0nfka9iyxs4wyaasjj9y1525va9s1z4fr";
    };
  });

  ## Non-code, configuration-only change

  adjunctions = overrideCabal super.adjunctions (drv: {
    ## Setup: Encountered missing dependencies:
    ## free ==4.*
    jailbreak       = true;
  });

  async = overrideCabal super.async (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.3 && <4.11
    jailbreak       = true;
  });

  bindings-GLFW = overrideCabal super.bindings-GLFW (drv: {
    ## Setup: Encountered missing dependencies:
    ## template-haskell >=2.10 && <2.13
    jailbreak       = true;
  });

  deepseq-generics = overrideCabal super.deepseq-generics (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    ## https://github.com/haskell-hvr/deepseq-generics/pull/4
    jailbreak       = true;
  });

  exception-transformers = overrideCabal super.exception-transformers (drv: {
    ## Setup: Encountered missing dependencies:
    ## HUnit >=1.2 && <1.6
    jailbreak       = true;
  });

  github = overrideCabal super.github (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11
    jailbreak       = true;
  });

  haddock-library_1_5_0_1 = overrideCabal super.haddock-library_1_5_0_1 (drv: {
    ## Setup: Encountered missing dependencies:
    ## QuickCheck ==2.11.*
    doCheck         = false;
    doHaddock       = false;
  });

  hashable = overrideCabal super.hashable (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.4 && <4.11
    jailbreak       = true;
  });

  hashable-time = overrideCabal super.hashable-time (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11
    jailbreak       = true;
  });

  haskell-src-meta = overrideCabal super.haskell-src-meta (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.6 && <4.11, template-haskell >=2.8 && <2.13
    jailbreak       = true;
  });

  hnix = overrideCabal super.hnix (drv: {
    ## Setup: Encountered missing dependencies:
    ## deriving-compat ==0.3.*
    jailbreak       = true;
  });

  integer-logarithms = overrideCabal super.integer-logarithms (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.3 && <4.11
    jailbreak       = true;
  });

  jailbreak-cabal = super.jailbreak-cabal.override {
    ##     • No instance for (Semigroup CDialect)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid CDialect’
    ## Undo the override in `configuration-common.nix`: GHC 8.4 bumps Cabal to 2.1:
    Cabal = self.Cabal;
  };

  kan-extensions = overrideCabal super.kan-extensions (drv: {
    ## Setup: Encountered missing dependencies:
    ## free ==4.*
    jailbreak       = true;
  });

  keys = overrideCabal super.keys (drv: {
    ## Setup: Encountered missing dependencies:
    ## free ==4.*
    jailbreak       = true;
  });

  lambdacube-gl = overrideCabal super.lambdacube-gl (drv: {
    ## Setup: Encountered missing dependencies:
    ## vector ==0.11.*
    jailbreak       = true;
  });

  lifted-async = overrideCabal super.lifted-async (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  newtype-generics = overrideCabal super.newtype-generics (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.6 && <4.11
    jailbreak       = true;
  });

  protolude = overrideCabal super.protolude (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.6 && <4.11
    jailbreak       = true;
  });

  quickcheck-instances = overrideCabal super.quickcheck-instances (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  rapid = overrideCabal super.rapid (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.8 && <4.11
    jailbreak       = true;
  });

  resolv = overrideCabal super.resolv (drv: {
    ## Setup: Encountered missing dependencies:
    ## tasty >=0.11.2 && <0.12
    doCheck         = false;
  });

  setlocale = overrideCabal super.setlocale (drv: {
    ## https://bitbucket.org/IchUndNichtDu/haskell-setlocale/issues/1/please-allow-base-412-from-ghc-841
    jailbreak       = true;
  });

  stylish-cabal = overrideCabal super.stylish-cabal (drv: {
    ## https://github.com/pikajude/stylish-cabal/issues/6
    doHaddock       = false;
  });

  tasty-expected-failure = overrideCabal super.tasty-expected-failure (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.5 && <4.11
    jailbreak       = true;
  });

  tasty-hedgehog = overrideCabal super.tasty-hedgehog (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.8 && <4.11
    jailbreak       = true;
  });

  ## Issue: https://github.com/ChrisPenner/rasa/issues/54
  text-lens = overrideCabal super.text-lens (drv: {
    ## Failures:
    ##   test/Spec.hs:136:
    ##   1) TextLens.range gets "" if invalid range
    ##        uncaught exception: ErrorCall (Data.Text.Array.new: size overflow
    ##        CallStack (from HasCallStack):
    ##          error, called at libraries/text/Data/Text/Array.hs:132:20 in text-1.2.3.0:Data.Text.Array)
    ## Randomized with seed 1899912238
    ## Finished in 0.0027 seconds
    doCheck         = false;
    ## Setup: Encountered missing dependencies:
    ## extra >=1.4.10 && <1.5, lens ==4.14.*
    jailbreak       = true;
  });

  ## Issue: https://github.com/phadej/tree-diff/issues/15
  tree-diff = overrideCabal super.tree-diff (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.7 && <4.11
    jailbreak       = true;
  });

  vector-algorithms = overrideCabal super.vector-algorithms (drv: {
    ##     • Ambiguous type variable ‘mv0’
    doCheck         = false;
  });

  wavefront = overrideCabal super.wavefront (drv: {
    ## Setup: Encountered missing dependencies:
    ## base >=4.8 && <4.11
    jailbreak       = true;
  });

  # https://github.com/jcristovao/enclosed-exceptions/issues/12
  enclosed-exceptions = dontCheck super.enclosed-exceptions;

  # Older versions don't compile.
  base-compat = self.base-compat_0_10_1;
  brick = self.brick_0_37;
  dhall = self.dhall_1_13_0;
  dhall_1_13_0 = doJailbreak super.dhall_1_13_0;  # support ansi-terminal 0.8.x
  HaTeX = self.HaTeX_3_19_0_0;
  hpack = self.hpack_0_28_2;
  hspec = dontCheck super.hspec_2_5_1;
  hspec-core = dontCheck super.hspec-core_2_5_1;
  hspec-discover = self.hspec-discover_2_5_1;
  hspec-smallcheck = self.hspec-smallcheck_0_5_2;
  matrix = self.matrix_0_3_6_1;
  pandoc = self.pandoc_2_2_1;
  pandoc-types = self.pandoc-types_1_17_4_2;
  wl-pprint-text = self.wl-pprint-text_1_2_0_0;

  # https://github.com/xmonad/xmonad/issues/155
  xmonad = addBuildDepend (appendPatch super.xmonad (pkgs.fetchpatch
    { url = https://github.com/xmonad/xmonad/pull/153/commits/c96a59fa0de2f674e60befd0f57e67b93ea7dcf6.patch;
      sha256 = "1mj3k0w8aqyy71kmc71vzhgxmr4h6i5b3sykwflzays50grjm5jp";
    })) self.semigroups;

  # https://github.com/xmonad/xmonad-contrib/issues/235
  xmonad-contrib = doJailbreak (appendPatch super.xmonad-contrib ./patches/xmonad-contrib-ghc-8.4.1-fix.patch);

  # Contributed by Bertram Felgenhauer <int-e@gmx.de>.
  arrows = appendPatch super.arrows (pkgs.fetchpatch {
    url = https://raw.githubusercontent.com/lambdabot/lambdabot/ghc-8.4.1/patches/arrows-0.4.4.1.patch;
    sha256 = "0j859vclcfnz8n2mw466mv00kjsa9gdbrppjc1m3b68jbypdmfvr";
  });

  # Contributed by Bertram Felgenhauer <int-e@gmx.de>.
  flexible-defaults = appendPatch super.flexible-defaults (pkgs.fetchpatch {
    url = https://raw.githubusercontent.com/lambdabot/lambdabot/ghc-8.4.1/patches/flexible-defaults-0.0.1.2.patch;
    sha256 = "1bpsqq80h6nxm04wddgcgyzn0fjfsmhccmqb211jqswv5209znx8";
  });

  lambdabot-core = appendPatch super.lambdabot-core ./patches/lambdabot-core-ghc-8.4.x-fix.patch;

}
