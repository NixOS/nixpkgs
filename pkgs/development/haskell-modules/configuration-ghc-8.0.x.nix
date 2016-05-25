{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_35;

  # Disable GHC 8.0.x core libraries.
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
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # cabal-install can use the native Cabal library.
  cabal-install = super.cabal-install.override { Cabal = null; };

  # jailbreak-cabal can use the native Cabal library.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # https://github.com/hspec/HUnit/issues/7
  HUnit = dontCheck super.HUnit;

  # https://github.com/hspec/hspec/issues/253
  hspec-core = dontCheck super.hspec-core;

  # Deviate from Stackage here to fix lots of builds.
  transformers-compat = self.transformers-compat_0_5_1_4;

  # No modules defined for this compiler.
  fail = dontHaddock super.fail;

  # Version 4.x doesn't compile with transformers 0.5 or later.
  comonad_5 = dontCheck super.comonad_5;  # https://github.com/ekmett/comonad/issues/33
  comonad = self.comonad_5;

  # Versions <= 5.2 don't compile with transformers 0.5 or later.
  bifunctors = self.bifunctors_5_3;

  # https://github.com/ekmett/semigroupoids/issues/42
  semigroupoids = dontCheck super.semigroupoids;

  # Version 4.x doesn't compile with transformers 0.5 or later.
  kan-extensions = self.kan-extensions_5_0_1;

  # Earlier versions don't support kan-extensions 5.x.
  lens = self.lens_4_14;

  # https://github.com/dreixel/generic-deriving/issues/37
  generic-deriving = dontHaddock super.generic-deriving;

  # https://github.com/haskell-suite/haskell-src-exts/issues/302
  haskell-src-exts = dontCheck super.haskell-src-exts;

  active         = doJailbreak super.active;

  authenticate-oauth = doJailbreak super.authenticate-oauth;

  diagrams-core  = doJailbreak super.diagrams-core;

  diagrams-lib   = doJailbreak super.diagrams-lib;

  foldl          = doJailbreak super.foldl;

  force-layout   = doJailbreak super.force-layout;

  # packaged 0.2.2.6 is missing: base >=4.7 && <4.9
  freer          = doJailbreak super.freer;

  # Partial fixes released in 1.20.5 upstream, full fixes only in git
  linear         = pkgs.haskell.lib.overrideCabal super.linear (oldAttrs: {
    editedCabalFile = null;
    revision        = null;
    src = pkgs.fetchgit {
            url    = https://github.com/ekmett/linear.git;
            rev    = "8da21dc72714441cb34d6eabd6c224819787365c";
            sha256 = "0f4r7ww8aygxv0mqdsn9d7fjvrvr66f04v004kh2v5d01dp8d7f9";
    };
  });

  lucid-svg      = doJailbreak super.lucid-svg;

  monads-tf      = doJailbreak super.monads-tf;

  parsers        = doJailbreak super.parsers;

  pointed        = super.pointed_5;

  reducers       = doJailbreak super.reducers;

  sdl2           = doJailbreak super.sdl2;

  servant        = dontCheck (doJailbreak super.servant_0_7);
  servant-client = dontCheck (doJailbreak super.servant-client_0_7);
  servant-server = dontCheck (doJailbreak super.servant-server_0_7);

  # packaged shelly 1.6.6 complains: time >=1.3 && <1.6
  shelly         = doJailbreak super.shelly;

  # The essential part is released in 2.1 upstream (needs hackage import)
  singletons     = (pkgs.haskell.lib.overrideCabal super.singletons (oldAttrs: {
    src = pkgs.fetchgit {
            url    = https://github.com/goldfirere/singletons.git;
            rev    = "277fa943e8c260973effb2291672b166bdd951c1";
            sha256 = "1ll9fcgs5nxqihvv5vr2bf9z6ijvn3yyk5ss3cgcfvcd95ayy1wz";
    };
  }));

  # The essential part only in upstream git, last released upstream version 2.7.0, Dec 8
  stm-conduit    = doJailbreak (pkgs.haskell.lib.overrideCabal super.stm-conduit (oldAttrs: {
    src          = pkgs.fetchgit {
            url    = https://github.com/cgaebel/stm-conduit.git;
            rev    = "3f831d703c422239e56a9da0f42db8a7059238e0";
            sha256 = "0bmym2ps0yjcsbyg02r8v1q8z5hpml99n72hf2pjmd31dy8iz7v9";
    };
  }));

  # The essential part only in upstream git, last released upstream version 1.6.0, Jan 27
  th-desugar          = doJailbreak (pkgs.haskell.lib.overrideCabal super.th-desugar (oldAttrs: {
    src = pkgs.fetchgit {
            url    = https://github.com/goldfirere/th-desugar.git;
            rev    = "7496de0243a12c14be1b37b89eb41cf9ef6f5229";
            sha256 = "10awknqviq7jb738r6n9rlyra0pvkrpnk0hikz4459hny4hamn75";
    };
  }));

  trifecta       = doJailbreak super.trifecta;

  turtle         = doJailbreak super.turtle;

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "dfeaab2aafdfefe46bf12960d069f28d2e5f1454"; # ghc-7.10 branch
      sha256 = "19kyb26nv1hdpp0kc2gaxkq5drw5ib4za0641py5i4bbf1g58yvy";
    };
    buildDepends = [ primitive ];
    license = pkgs.stdenv.lib.licenses.bsd3;
  }) {};

  MonadCatchIO-transformers = doJailbreak super.MonadCatchIO-transformers;
}
