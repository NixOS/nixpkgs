{
  lib,
  callPackage,
  llvmPackages_18,
  llvmPackages_19,
  llvmPackages_20,
  zigVersions ? { },
}:
let
  versions = {
    "0.13.0" = {
      llvmPackages = llvmPackages_18;
      hash = "sha256-5qSiTq+UWGOwjDVZMIrAt2cDKHkyNPBSAEjpRQUByFM=";
    };
    "0.14.1" = {
      llvmPackages = llvmPackages_19;
      hash = "sha256-DhVJIY/z12PJZdb5j4dnCRb7k1CmeQVOnayYRP8azDI=";
    };
    "0.15.1" = {
      llvmPackages = llvmPackages_20;
      hash = "sha256-RFbJYeTHj/aNjWSsG+HHtmOL1VY4dpvJjbx04OhF4bI=";
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
