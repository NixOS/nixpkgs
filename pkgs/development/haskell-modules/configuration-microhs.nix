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
  ghc-compat = doDistribute (markUnbroken super.ghc-compat);

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
  binary = markBroken self.binary_0_8_9_3;
  Cabal = doDistribute self.Cabal_3_16_1_0;
  Cabal-syntax = doDistribute self.Cabal-syntax_3_16_1_0;
  containers = doDistribute self.containers_0_8;
  exceptions = doDistribute self.exceptions_0_10_12;
  filepath = doDistribute self.filepath_1_5_5_0;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghci = null;
  haskeline = doDistribute self.haskeline_0_8_4_1;
  hpc = markBroken self.hpc_0_7_0_2;
  integer-gmp = markBroken self.integer-gmp_1_1;
  libiserv = null;
  mtl = doDistribute self.mtl_2_3_2;
  os-string = doDistribute self.os-string_2_0_10;
  parsec = doDistribute self.parsec_3_1_18_0;
  pretty = markBroken self.pretty_1_1_3_6;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  terminfo = doDistribute self.terminfo_0_4_1_7;
  time = doDistribute self.time_1_15;
  transformers = doDistribute self.transformers_0_6_3_0;
  unix = markBroken self.unix_2_8_8_0;
  xhtml = markBroken self.xhtml_3000_4_0_0;

  # MicroHs replacements for widely used libraries
  array = self.array-mhs;
  array-mhs = doDistribute (markUnbroken super.array-mhs);
  random = self.random-mhs;
  random-mhs = doDistribute (markUnbroken super.random-mhs);

  # Depends on time when not using GHC
  splitmix = addBuildDepends [ self.time ] super.splitmix;
}
