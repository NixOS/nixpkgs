{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 9.x.
  llvmPackages = pkgs.llvmPackages_9;

  # Disable GHC 8.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
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

  # cabal-install needs more recent versions of Cabal and random, but an older
  # version of base16-bytestring.
  cabal-install = super.cabal-install.overrideScope (self: super: {
    Cabal = self.Cabal_3_4_0_0;
    base16-bytestring = self.base16-bytestring_0_1_1_7;
    random = dontCheck super.random_1_2_0;  # break infinite recursion
    hashable = doJailbreak super.hashable;  # allow random 1.2.x
  });

  # cabal-install-parsers is written for Cabal 3.4
  cabal-install-parsers = super.cabal-install-parsers.override { Cabal = super.Cabal_3_4_0_0; };

  # Jailbreak to fix the build.
  base-noprelude = doJailbreak super.base-noprelude;
  system-fileio = doJailbreak super.system-fileio;
  unliftio-core = doJailbreak super.unliftio-core;

  # Jailbreaking because monoidal-containers hasn‘t bumped it's base dependency for 8.10.
  monoidal-containers = doJailbreak super.monoidal-containers;

  # Jailbreak to fix the build.
  brick = doJailbreak super.brick;
  exact-pi = doJailbreak super.exact-pi;
  serialise = doJailbreak super.serialise;
  setlocale = doJailbreak super.setlocale;
  shellmet = doJailbreak super.shellmet;
  shower = doJailbreak super.shower;

  # The shipped Setup.hs file is broken.
  csv = overrideCabal super.csv (drv: { preCompileBuildDriver = "rm Setup.hs"; });

  # Apply patch from https://github.com/finnsson/template-helper/issues/12#issuecomment-611795375 to fix the build.
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    name = "language-haskell-extract-0.2.4.patch";
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/e48738ee1be774507887a90a0d67ad1319456afc/patches/language-haskell-extract-0.2.4.patch?inline=false";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  });

  # hnix 0.9.0 does not provide an executable for ghc < 8.10, so define completions here for now.
  hnix = generateOptparseApplicativeCompletion "hnix"
    (overrideCabal super.hnix (drv: {
      # executable is allowed for ghc >= 8.10 and needs repline
      executableHaskellDepends = drv.executableToolDepends or [] ++ [ self.repline ];
    }));

  # Break out of "Cabal < 3.2" constraint.
  stylish-haskell = doJailbreak super.stylish-haskell;

}
