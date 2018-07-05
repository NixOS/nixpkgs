{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Use the latest LLVM.
  inherit (pkgs) llvmPackages;

  # Use to be a core-library, but no longer is since GHC 8.4.x.
  hoopl = self.hoopl_3_10_2_2;

}
