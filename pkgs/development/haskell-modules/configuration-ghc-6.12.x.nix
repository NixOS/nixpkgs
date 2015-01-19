{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Disable GHC 6.12.x core libraries.
  array = null;
  base = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  directory = null;
  dph-base = null;
  dph-par = null;
  dph-prim-interface = null;
  dph-prim-par = null;
  dph-prim-seq = null;
  dph-seq = null;
  extensible-exceptions = null;
  ffi = null;
  filepath = null;
  ghc-binary = null;
  ghc-prim = null;
  haskell98 = null;
  hpc = null;
  integer-gmp = null;
  old-locale = null;
  old-time = null;
  pretty = null;
  process = null;
  random = null;
  rts = null;
  syb = null;
  template-haskell = null;
  time = null;
  unix = null;

  # binary is not a core library for this compiler.
  binary = self.binary_0_7_2_3;

  # deepseq is not a core library for this compiler.
  deepseq_1_3_0_1 = dontJailbreak super.deepseq_1_3_0_1;
  deepseq = self.deepseq_1_3_0_1;

  # transformers is not a core library for this compiler.
  transformers = self.transformers_0_4_2_0;
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # Needs Cabal >= 1.18.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_18_1_6; };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # https://github.com/glguy/utf8-string/issues/9
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -ir -e 's|Extensions: | Extensions: UndecidableInstances, |' utf8-string.cabal";
  });

  # https://github.com/haskell/HTTP/issues/80
  HTTP = doJailbreak super.HTTP;

  # 6.12.3 doesn't support the latest version.
  primitive = self.primitive_0_5_1_0;

  # These packages need more recent versions of core libraries to compile.
  happy = addBuildTools super.happy [self.Cabal_1_18_1_6 self.containers_0_4_2_1];
  network-uri = addBuildTool super.network-uri self.Cabal_1_18_1_6;
  stm = addBuildTool super.stm self.Cabal_1_18_1_6;
  split = super.split_0_1_4_3;

}
