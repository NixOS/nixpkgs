{ pkgs, haskellLib }:

self: super:

with haskellLib;

let
  inherit (pkgs) lib;

  warnAfterVersion =
    ver: pkg:
    lib.warnIf (lib.versionOlder ver
      super.${pkg.pname}.version
    ) "override for haskell.packages.ghc910.${pkg.pname} may no longer be needed" pkg;

in

{
  # Disable GHC core libraries
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-experimental = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghc-toolchain = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  os-string = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo =
    if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then
      null
    else
      doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;
  Win32 = null;

  # “Unfortunately we are unable to support GHC 9.10.”
  apply-refact = dontDistribute (markBroken super.apply-refact);

  stack =
    # Setup.hs depends on Cabal-syntax >= 3.14
    overrideCabal
      (drv: {
        setupHaskellDepends = drv.setupHaskellDepends or [ ] ++ [
          self.Cabal-syntax_3_14_2_0
          self.Cabal_3_14_2_0
        ];
        # We need to tell GHC to ignore the Cabal core libraries while
        # compiling Setup.hs since it depends on Cabal >= 3.14.
        # ATTN: This override assumes we are using GHC 9.10.3 since we need
        # to give an exact Cabal version at the GHC (!) command line.
        # FIXME(@sternenseemann): make direct argument to generic-builder.nix
        env = drv.env or { } // {
          setupCompileFlags = lib.concatStringsSep " " [
            "-hide-package"
            "Cabal-syntax-3.12.1.0"
            "-hide-package"
            "Cabal-3.12.1.0"
          ];
        };
      })

      # Stack itself depends on Cabal >= 3.14 which also needs to be updated for deps
      (
        super.stack.overrideScope (
          sself: ssuper:
          let
            upgradeCabal =
              drv:
              lib.pipe drv [
                (addBuildDepends [ sself.Cabal_3_14_2_0 ])
                (appendConfigureFlags [ "--constraint=Cabal>=3.14" ])
              ];
          in
          {
            pantry = upgradeCabal ssuper.pantry_0_11_2;
            rio-prettyprint = upgradeCabal ssuper.rio-prettyprint;
            hackage-security = upgradeCabal ssuper.hackage-security;
            hpack = upgradeCabal sself.hpack_0_39_1;
            stack = upgradeCabal ssuper.stack;
          }
        )
      );

  #
  # Version upgrades
  #

  # Upgrade to accommodate new core library versions, where the authors have
  # already made the relevant changes.

  #
  # Jailbreaks
  #
  floskell = doJailbreak super.floskell; # base <4.20
  # 2025-04-09: filepath <1.5
  haddock-library =
    assert super.haddock-library.version == "1.11.0";
    doJailbreak super.haddock-library;
  tree-sitter = doJailbreak super.tree-sitter; # containers <0.7, filepath <1.5

  #
  # Test suite issues
  #
  monad-dijkstra = dontCheck super.monad-dijkstra; # needs hlint 3.10

  # Workaround https://github.com/haskell/haskell-language-server/issues/4674
  haskell-language-server = haskellLib.disableCabalFlag "hlint" super.haskell-language-server;

}
