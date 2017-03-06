{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

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

  # These packages are core libraries in GHC 7.10.x, but not here.
  binary = self.binary_0_8_4_1;
  deepseq = self.deepseq_1_3_0_1;
  haskeline = self.haskeline_0_7_3_1;
  hoopl = self.hoopl_3_10_2_0;
  terminfo = self.terminfo_0_4_0_2;
  transformers = self.transformers_0_4_3_0;
  xhtml = self.xhtml_3000_2_1;

  # We have no working cabal-install at the moment.
  cabal-install = markBroken super.cabal-install;

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # Needs Cabal >= 1.18.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_18_1_7; };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # https://github.com/glguy/utf8-string/issues/9
  utf8-string = overrideCabal super.utf8-string (drv: {
    configureFlags = drv.configureFlags or [] ++ ["-f-bytestring-in-base" "--ghc-option=-XUndecidableInstances"];
    preConfigure = "sed -i -e 's|base >= .* < .*,|base,|' utf8-string.cabal";
  });

  # https://github.com/haskell/HTTP/issues/80
  HTTP = doJailbreak super.HTTP;

  # 6.12.3 doesn't support the latest version.
  primitive = self.primitive_0_5_1_0;
  parallel = self.parallel_3_2_0_3;
  vector = self.vector_0_10_9_3;

  # These packages need more recent versions of core libraries to compile.
  happy = addBuildTools super.happy [self.Cabal_1_18_1_7 self.containers_0_4_2_1];
  network-uri = addBuildTool super.network-uri self.Cabal_1_18_1_7;
  stm = addBuildTool super.stm self.Cabal_1_18_1_7;
  split = super.split_0_1_4_3;

  # Needs hashable on pre 7.10.x compilers.
  nats_1 = addBuildDepend super.nats_1 self.hashable;
  nats = addBuildDepend super.nats self.hashable;

  # Needs void on pre 7.10.x compilers.
  conduit = addBuildDepend super.conduit self.void;

}
