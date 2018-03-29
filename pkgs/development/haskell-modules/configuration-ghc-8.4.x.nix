{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Use the latest LLVM.
  inherit (pkgs) llvmPackages;

  # Disable GHC 8.4.x core libraries.
  #
  # Verify against:
  # ls /nix/store/wnh3kxra586h9wvxrn62g4lmsri2akds-ghc-8.4.20180115/lib/ghc-8.4.20180115/ -1 | sort | grep -e '-' | grep -Ev '(txt|h|targets)$'
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  bin-package-db = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghci = null;
  ghc-prim = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
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
  ##     • No instance for (GHC.Base.Semigroup BV)
  ##         arising from the superclasses of an instance declaration
  ##     • In the instance declaration for ‘Monoid BV’
  bv = super.bv_0_5;

  ## Needs bump to a versioned attribute
  ## Setup: Encountered missing dependencies:
  ## template-haskell >=2.5 && <2.13
  deriving-compat = super.deriving-compat_0_4_1;

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

  ## Needs bump to a versioned attribute
  hspec = overrideCabal super.hspec_2_5_0 (drv: {
    ## Setup: Encountered missing dependencies:
    ## hspec-core ==2.4.4, hspec-discover ==2.4.4
    ##
    ## error: while evaluating the attribute ‘buildInputs’ of the derivation ‘hspec-2.4.8’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘stringbuilder-0.5.1’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## infinite recursion encountered, at undefined position
    ## test suite causes an infinite loop
    doCheck         = false;
  });

  ## Needs bump to a versioned attribute
  hspec-core = overrideCabal super.hspec-core_2_5_0 (drv: {
    ##     • No instance for (Semigroup Summary)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Summary’
    ##
    ## error: while evaluating the attribute ‘buildInputs’ of the derivation ‘hspec-core-2.4.8’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘silently-1.2.5’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘temporary-1.2.1.1’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘buildInputs’ of the derivation ‘base-compat-0.9.3’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## while evaluating the attribute ‘propagatedBuildInputs’ of the derivation ‘hspec-2.4.8’ at nixpkgs://pkgs/stdenv/generic/make-derivation.nix:148:11:
    ## infinite recursion encountered, at undefined position
    doCheck         = false;
  });

  ## Needs bump to a versioned attribute
  ## Setup: Encountered missing dependencies:
  ## hspec-discover ==2.4.8
  hspec-discover = super.hspec-discover_2_5_0;

  ## On Hackage:

  ## Upstreamed, awaiting a Hackage release
  cabal-install = overrideCabal super.cabal-install (drv: {
    ## Setup: Encountered missing dependencies:
    ## Cabal >=2.0.1.0 && <2.1, base >=4.5 && <4.11
    src = pkgs.fetchFromGitHub {
      owner  = "haskell";
      repo   = "cabal";
      rev    = "728ad1a1e066da453ae13ee479629c00d8c2f32d";
      sha256 = "0943xpva0fjlx8fanqvb6bg7myim2pki7q8hz3q0ijnf73bgzf7p";
    };
    prePatch        = "cd cabal-install; ";
    ## Setup: Encountered missing dependencies:
    ## network >=2.4 && <2.6, resolv >=0.1.1 && <0.2
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ (with self; [ network resolv ]);
  });

  ## Upstreamed, awaiting a Hackage release
  hackage-security = overrideCabal super.hackage-security (drv: {
    ## Setup: Encountered missing dependencies:
    ## Cabal >=1.14 && <1.26,
    ## directory >=1.1.0.2 && <1.3,
    ## time >=1.2 && <1.7
    src = pkgs.fetchFromGitHub {
      owner  = "haskell";
      repo   = "hackage-security";
      rev    = "21519f4f572b9547485285ebe44c152e1230fd76";
      sha256 = "1ijwmps4pzyhsxfhc8mrnc3ldjvpisnmr457vvhgymwhdrr95k0z";
    };
    prePatch        = "cd hackage-security; ";
    ## https://github.com/haskell/hackage-security/issues/211
    jailbreak       = true;
    ## error: while evaluating ‘overrideCabal’ at nixpkgs://pkgs/development/haskell-modules/lib.nix:37:24, called from /home/deepfire/nixpkgs/pkgs/development/haskell-modules/configuration-ghc-8.4.x.nix:217:22:
    editedCabalFile = null;
  });

  ## Upstreamed, awaiting a Hackage release
  haskell-gi = overrideCabal super.haskell-gi (drv: {
    ## Setup: Encountered missing dependencies:
    ## haskell-gi-base ==0.20.*
    src = pkgs.fetchFromGitHub {
      owner  = "haskell-gi";
      repo   = "haskell-gi";
      rev    = "30d2e6415c5b57760f8754cd3003eb07483d60e6";
      sha256 = "1l3qm97gcjih695hhj80rbpnd72prnc81lg5y373yj8jk9f6ypbr";
    };
  });

  ## Upstreamed, awaiting a Hackage release
  haskell-gi-base = overrideCabal super.haskell-gi-base (drv: {
    ## Setup: Encountered missing dependencies:
    ## haskell-gi-base ==0.21.*
    src = pkgs.fetchFromGitHub {
      owner  = "haskell-gi";
      repo   = "haskell-gi";
      rev    = "30d2e6415c5b57760f8754cd3003eb07483d60e6";
      sha256 = "1l3qm97gcjih695hhj80rbpnd72prnc81lg5y373yj8jk9f6ypbr";
    };
    prePatch        = "cd base; ";
  });

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

  ## Upstreamed, awaiting a Hackage release
  simple-reflect = overrideCabal super.simple-reflect (drv: {
    ##     • No instance for (Semigroup Expr)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Expr’
    src = pkgs.fetchFromGitHub {
      owner  = "twanvl";
      repo   = "simple-reflect";
      rev    = "c357e55da9a712dc5dbbfe6e36394e4ada2db310";
      sha256 = "15q41b00l8y51xzhbj5zhddyh3gi7gvml033w8mm2fih458jf6yq";
    };
  });

  singletons = super.singletons_2_4_1;

  ## Upstreamed, awaiting a Hackage release
  tar = overrideCabal super.tar (drv: {
    ##     • No instance for (Semigroup (Entries e))
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid (Entries e)’
    src = pkgs.fetchFromGitHub {
      owner  = "haskell";
      repo   = "tar";
      rev    = "abf2ccb8f7da0514343a0b2624cabebe081bdfa8";
      sha256 = "0s33lgrr574i1r7zc1jqahnwx3dv47ny30mbx5zfpdzjw0jdl5ny";
    };
  });

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

  ## Unmerged.  PR: https://github.com/dhall-lang/dhall-haskell/pull/321
  dhall = overrideCabal super.dhall (drv: {
    ##     • No instance for (Semigroup (Parser Builder))
    ##         arising from a use of ‘<>’
    ##       There are instances for similar types:
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "dhall-haskell";
      rev    = "38f3d8c861e137da6d8ac8eab88aec1c359efcac";
      sha256 = "1pya7lhdjsygk622k1g3whj0a7jqwyym26ikxbn1anxypnb0n2wy";
    };
    ## Setup: Encountered missing dependencies:
    ## prettyprinter >=1.2.0.1 && <1.3
    jailbreak       = true;
    ## Setup: Encountered missing dependencies:
    ## insert-ordered-containers -any,
    ## lens-family-core -any,
    ## prettyprinter-ansi-terminal -any,
    ## repline -any
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ (with self; [ insert-ordered-containers lens-family-core prettyprinter prettyprinter-ansi-terminal repline ]);
  });

  ## Unmerged.  PR: https://github.com/gtk2hs/gtk2hs/pull/233
  gtk2hs-buildtools = overrideCabal super.gtk2hs-buildtools (drv: {
    ## Setup: Encountered missing dependencies:
    ## Cabal >=1.24.0.0 && <2.1
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "gtk2hs";
      rev    = "08c68d5afc22dd5761ec2c92ebf49c6d252e545b";
      sha256 = "06prn5wqq8x225n9wlbyk60f50jyjj8fm2hf181dyqjpf8wq75xa";
    };
    prePatch        = "cd tools; ";
  });

  ## Unmerged.  PR: https://github.com/gregorycollins/hashtables/pull/46
  hashtables = overrideCabal super.hashtables (drv: {
    ##     • No instance for (Semigroup Slot)
    ##         arising from the superclasses of an instance declaration
    ##     • In the instance declaration for ‘Monoid Slot’
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "hashtables";
      rev    = "b9eb4b10a50bd6250330422afecc065339a32412";
      sha256 = "0l4nplpvnzzf397zyh7j2k6yiqb46k6bdy00m4zzvhlfp7p1xkaw";
    };
  });

  ## Unmerged.  PR: https://github.com/sol/hpack/pull/277
  ## Issue: https://github.com/sol/hpack/issues/276
  hpack = overrideCabal super.hpack (drv: {
    ##     • No instance for (Semigroup Dependencies)
    ##         arising from the 'deriving' clause of a data type declaration
    ##       Possible fix:
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "hpack";
      rev    = "acce0cffcc1d165a0fd9f0b83878dfbd622ea0d6";
      sha256 = "1wv0ya1gb1hwd9w8g4z5aig694q3arsqhxv0d4wcp270xnq9ja8y";
    };
    ## Setup: Encountered missing dependencies:
    ## http-client -any, http-client-tls -any, http-types -any
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ (with self; [ http-client http-client-tls http-types ]);
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

  ## Unmerged.  PR: https://github.com/ivan-m/wl-pprint-text/pull/17
  wl-pprint-text = overrideCabal super.wl-pprint-text (drv: {
    ##     Ambiguous occurrence ‘<>’
    ##     It could refer to either ‘PP.<>’,
    ##                              imported from ‘Prelude.Compat’ at Text/PrettyPrint/Leijen/Text/Monadic.hs:73:1-36
    src = pkgs.fetchFromGitHub {
      owner  = "deepfire";
      repo   = "wl-pprint-text";
      rev    = "615b83d1e5be52d1448aa1ab2517b431a617027b";
      sha256 = "1p67v9s878br0r152h4n37smqhkg78v8zxhf4qm6d035s4rzj76i";
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

  # Fix missing semigroup instance.
  data-inttrie = appendPatch super.data-inttrie (pkgs.fetchpatch
    { url = https://github.com/luqui/data-inttrie/pull/5.patch;
      sha256 = "1wwdzrbsjqb7ih4nl28sq5bbj125mxf93a74yh4viv5gmxwj606a";
    });

  # Older versions don't compile.
  brick = self.brick_0_35_1;
  HaTeX = self.HaTeX_3_19_0_0;
  matrix = self.matrix_0_3_6_1;
  pandoc = self.pandoc_2_1_3;
  pandoc-types = self.pandoc-types_1_17_4_2;

  # https://github.com/xmonad/xmonad/issues/155
  xmonad = addBuildDepend (appendPatch super.xmonad (pkgs.fetchpatch
    { url = https://github.com/xmonad/xmonad/pull/153/commits/c96a59fa0de2f674e60befd0f57e67b93ea7dcf6.patch;
      sha256 = "1mj3k0w8aqyy71kmc71vzhgxmr4h6i5b3sykwflzays50grjm5jp";
    })) self.semigroups;

  # https://github.com/xmonad/xmonad-contrib/issues/235
  xmonad-contrib = doJailbreak (appendPatch super.xmonad-contrib ./patches/xmonad-contrib-ghc-8.4.1-fix.patch);

}
