{ pkgs, haskellLib }:

with haskellLib;

self: super: {
  # Disable MicroHs core libraries
  base = null;
  bytestring = null;
  deepseq = null;
  directory = null;
  process = null;
  text = null;
  MicroHs = null;

  # External MicroHs core libraries
  ghc-compat = markUnbroken super.ghc-compat;

  # Bootstrap MicroCabal
  MicroCabal = self.mkDerivation {
    pname = "MicroCabal";
    version = self.ghc.microcabal-stage1.version;
    src = self.ghc.microcabal-stage1.src;
    isLibrary = false;
    isExecutable = true;
    executableHaskellDepends = with self; [ base ];
    inherit (self.ghc.microcabal-stage1.meta)
      description
      homepage
      license
      mainProgram
      maintainers
      ;
  };

  # hackage-packages does not include GHC core libraries
  binary = self.binary_0_8_9_3;
  Cabal = self.Cabal_3_16_1_0;
  Cabal-syntax = self.Cabal-syntax_3_16_1_0;
  containers = self.containers_0_8;
  exceptions = self.exceptions_0_10_12;
  filepath = self.filepath_1_5_5_0;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghci = null;
  haskeline = self.haskeline_0_8_4_1;
  hpc = self.hpc_0_7_0_2;
  integer-gmp = self.integer-gmp_1_1;
  libiserv = null;
  mtl = self.mtl_2_3_2;
  os-string = self.os-string_2_0_10;
  parsec = self.parsec_3_1_18_0;
  pretty = self.pretty_1_1_3_6;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  terminfo = self.terminfo_0_4_1_7;
  time = self.time_1_15;
  transformers = self.transformers_0_6_3_0;
  unix = self.unix_2_8_8_0;
  xhtml = self.xhtml_3000_4_0_0;

  # MicroHs replacements for widely used libraries
  array = self.array-mhs;
  array-mhs = markUnbroken super.array-mhs;
  random = self.random-mhs;
  random-mhs = markUnbroken super.random-mhs;

  # Depends on time when not using GHC
  splitmix = addBuildDepends [ self.time ] super.splitmix;
}
