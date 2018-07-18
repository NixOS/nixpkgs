{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 5.x.
  llvmPackages = pkgs.llvmPackages_5;

  # Use to be a core-library, but no longer is since GHC 8.4.x.
  hoopl = self.hoopl_3_10_2_2;

  # lts-12.x versions do not compile.
  primitive = self.primitive_0_6_4_0;
  tagged = self.tagged_0_8_6;

  # Over-specified constraints.
  async = doJailbreak super.async;                           # base >=4.3 && <4.12, stm >=2.2 && <2.5
  ChasingBottoms = doJailbreak super.ChasingBottoms;         # base >=4.2 && <4.12, containers >=0.3 && <0.6
  hashable = doJailbreak super.hashable;                     # base >=4.4 && <4.1
  hashable-time = doJailbreak super.hashable-time;           # base >=4.7 && <4.12
  integer-logarithms = doJailbreak super.integer-logarithms; # base >=4.3 && <4.12
  tar = doJailbreak super.tar;                               # containers >=0.2 && <0.6
  test-framework = doJailbreak super.test-framework;         # containers >=0.1 && <0.6

}
