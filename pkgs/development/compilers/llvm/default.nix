{
  lib,
  callPackage,
  stdenvAdapters,
  buildPackages,
  targetPackages,
  stdenv,
  gcc12Stdenv,
  pkgs,
  recurseIntoAttrs,
  # This is the default binutils, but with *this* version of LLD rather
  # than the default LLVM version's, if LLD is the choice. We use these for
  # the `useLLVM` bootstrapping below.
  bootBintoolsNoLibc ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintoolsNoLibc,
  bootBintools ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintools,
  llvmVersions ? { },
  # Allows passthrough to packages via newScope in ./common/default.nix.
  # This makes it possible to do
  # `(llvmPackages.override { <someLlvmDependency> = bar; }).clang` and get
  # an llvmPackages whose packages are overridden in an internally consistent way.
  ...
}@packageSetArgs:
let
  versions = {
    "13.0.1".officialRelease.sha256 = "06dv6h5dmvzdxbif2s8njki6h32796v368dyb5945x8gjj72xh7k";
    "14.0.6".officialRelease.sha256 = "sha256-vffu4HilvYwtzwgq+NlS26m65DGbp6OSSne2aje1yJE=";
    "15.0.7".officialRelease.sha256 = "sha256-wjuZQyXQ/jsmvy6y1aksCcEDXGBjuhpgngF3XQJ/T4s=";
    "16.0.6".officialRelease.sha256 = "sha256-fspqSReX+VD+Nl/Cfq+tDcdPtnQPV1IRopNDfd5VtUs=";
    "17.0.6".officialRelease.sha256 = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
    "18.1.8".officialRelease.sha256 = "sha256-iiZKMRo/WxJaBXct9GdAcAT3cz9d9pnAcO1mmR6oPNE=";
    "19.1.4".officialRelease.sha256 = "sha256-qi1a/AWxF5j+4O38VQ2R/tvnToVAlMjgv9SP0PNWs3g=";
    "20.0.0-git".gitRelease = {
      rev = "0e8555d4dbfdfeddc01dc2ecf9a9b6e804f7b645";
      rev-version = "20.0.0-unstable-2024-10-07";
      sha256 = "sha256-Rn8TkTUJKGFZ7uM1RiFOHIDTfpwEhLDpDh1zxVtTYG8=";
    };
  } // llvmVersions;

  mkPackage =
    {
      name ? null,
      officialRelease ? null,
      gitRelease ? null,
      monorepoSrc ? null,
      version ? null,
    }@args:
    let
      inherit
        (import ./common/common-let.nix {
          inherit lib;
          inherit gitRelease officialRelease version;
        })
        releaseInfo
        ;
      inherit (releaseInfo) release_version;
      attrName =
        args.name or (if (gitRelease != null) then "git" else lib.versions.major release_version);
    in
    lib.nameValuePair attrName (
      recurseIntoAttrs (
        callPackage ./common (
          {
            inherit (stdenvAdapters) overrideCC;
            buildLlvmTools = buildPackages."llvmPackages_${attrName}".tools;
            targetLlvmLibraries =
              # Allow overriding targetLlvmLibraries; this enables custom runtime builds.
              packageSetArgs.targetLlvmLibraries or targetPackages."llvmPackages_${attrName}".libraries
                or llvmPackages."${attrName}".libraries;
            targetLlvm = targetPackages."llvmPackages_${attrName}".llvm or llvmPackages."${attrName}".llvm;
            inherit
              officialRelease
              gitRelease
              monorepoSrc
              version
              ;
          }
          // packageSetArgs # Allow overrides.
          // {
            stdenv =
              if (lib.versions.major release_version == "13" && stdenv.cc.cc.isGNU or false) then
                gcc12Stdenv
              else
                stdenv; # does not build with gcc13
          }
        )
      )
    );

  llvmPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
llvmPackages // { inherit mkPackage; }
