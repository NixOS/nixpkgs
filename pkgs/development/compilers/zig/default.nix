{
  lib,
  callPackage,
  llvmPackages_17,
  llvmPackages_18,
  llvmPackages_19,
  zigVersions ? { },
}:
let
  versions = {
    "0.12.1" = {
      llvmPackages = llvmPackages_17;
      hash = "sha256-C56jyVf16Co/XCloMLSRsbG9r/gBc8mzCdeEMHV2T2s=";
    };
    "0.13.0" = {
      llvmPackages = llvmPackages_18;
      hash = "sha256-5qSiTq+UWGOwjDVZMIrAt2cDKHkyNPBSAEjpRQUByFM=";
    };
    "0.14.1" = {
      llvmPackages = llvmPackages_19;
      hash = "sha256-DhVJIY/z12PJZdb5j4dnCRb7k1CmeQVOnayYRP8azDI=";
    };
  }
  // zigVersions;

  mkPackage =
    {
      version,
      hash,
      llvmPackages,
    }@args:
    callPackage ./generic.nix args;

  zigPackages = lib.mapAttrs' (
    version: args:
    lib.nameValuePair (lib.versions.majorMinor version) (mkPackage (args // { inherit version; }))
  ) versions;
in
zigPackages
