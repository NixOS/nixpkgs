{
  lib,
  callPackage,
  llvmPackages_16,
  llvmPackages_17,
  llvmPackages_18,
  llvmPackages_19,
  zigVersions ? { },
}:
let
  versions = {
    "0.11.0" = {
      llvmPackages = llvmPackages_16;
      hash = "sha256-iuU1fzkbJxI+0N1PiLQM013Pd1bzrgqkbIyTxo5gB2I=";
    };
    "0.12.1" = {
      llvmPackages = llvmPackages_17;
      hash = "sha256-C56jyVf16Co/XCloMLSRsbG9r/gBc8mzCdeEMHV2T2s=";
    };
    "0.13.0" = {
      llvmPackages = llvmPackages_18;
      hash = "sha256-5qSiTq+UWGOwjDVZMIrAt2cDKHkyNPBSAEjpRQUByFM=";
    };
    "0.14.0" = {
      llvmPackages = llvmPackages_19;
      hash = "sha256-VyteIp5ZRt6qNcZR68KmM7CvN2GYf8vj5hP+gHLkuVk=";
    };
  } // zigVersions;

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
