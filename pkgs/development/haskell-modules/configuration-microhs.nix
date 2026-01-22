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
  array = self.array-mhs;
  array-mhs = markUnbroken super.array-mhs;
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
  Cabal = self.Cabal_3_16_0_0;
  Cabal-syntax = self.Cabal-syntax_3_16_0_0;
  containers = self.containers_0_8;
  exceptions = self.exceptions_0_10_11;
  filepath = self.filepath_1_5_4_0;
  ghc-bignum = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = self.haskeline_0_8_4_1;
  hpc = self.hpc_0_7_0_2;
  integer-gmp = self.integer-gmp_1_1;
  libiserv = null;
  mtl = appendPatches [
    (pkgs.fetchpatch {
      url = "https://github.com/haskell/mtl/commit/f2b6d233f3ab6595fd4a9db7e4f446e21e937d8c.patch";
      name = "revert-polykinded-cont.patch";
      includes = [ "Control/Monad/Cont/Class.hs" ];
      revert = true;
      hash = "sha256-ZhH4Qkil1lHhqSmnwiUw5caOPyvX9uhHQvsovoI74Q4=";
    })
  ] self.mtl_2_3_1;
  os-string = self.os-string_2_0_8;
  parsec = self.parsec_3_1_18_0;
  pretty = self.pretty_1_1_3_6;
  rts = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  terminfo = self.terminfo_0_4_1_7;
  time = self.time_1_15;
  transformers = self.transformers_0_6_2_0;
  unix = self.unix_2_8_8_0;
  xhtml = self.xhtml_3000_4_0_0;
}
