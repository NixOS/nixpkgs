{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.1.2";
  branch = "2.1";
  revision = "v2.1.2";
  sha256 = "0kdcl9sqjz0vagli4ad6bxq1r8ma086m0prpkm5x3dxp37hpjp8h";
})
