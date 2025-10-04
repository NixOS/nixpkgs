{
  lib,
  callPackage,
  stdenvAdapters,
  buildPackages,
  targetPackages,
  stdenv,
  pkgs,
  recurseIntoAttrs,
  # This is the default binutils, but with *this* version of LLD rather
  # than the default LLVM version's, if LLD is the choice. We use these for
  # the `useLLVM` bootstrapping below.
  bootBintoolsNoLibc ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintoolsNoLibc,
  bootBintools ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintools,
  llvmVersions ? { },
  patchesFn ? lib.id,
  # Allows passthrough to packages via newScope in ./common/default.nix.
  # This makes it possible to do
  # `(llvmPackages.override { <someLlvmDependency> = bar; }).clang` and get
  # an llvmPackages whose packages are overridden in an internally consistent way.
  ...
}@packageSetArgs:
let
  versions = {
    "18.1.8".officialRelease.sha256 = "sha256-iiZKMRo/WxJaBXct9GdAcAT3cz9d9pnAcO1mmR6oPNE=";
    "19.1.7".officialRelease.sha256 = "sha256-cZAB5vZjeTsXt9QHbP5xluWNQnAHByHtHnAhVDV0E6I=";
    "20.1.8".officialRelease.sha256 = "sha256-ysyB/EYxi2qE9fD5x/F2zI4vjn8UDoo1Z9ukiIrjFGw=";
    "21.1.1".officialRelease.sha256 = "sha256-IB9Z3bIMwfgw2W2Vxo89CmtCM9DfOyV2Ei64nqgHrgc=";
    "22.0.0-git".gitRelease = {
      rev = "cac0635ee9e947b5f90130df2f471aa4b722e04b";
      rev-version = "22.0.0-unstable-2025-09-28";
      sha256 = "sha256-wOhLGRYbkJOM6uglKXWZ7/94w/Fi3K2tlyPWdOVsCvM=";
    };
  }
  // llvmVersions;

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
              patchesFn
              ;
          }
          // packageSetArgs # Allow overrides.
        )
      )
    );

  llvmPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
llvmPackages // { inherit mkPackage versions; }
