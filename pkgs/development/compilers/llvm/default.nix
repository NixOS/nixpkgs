{
  lib,
  callPackage,
  stdenvAdapters,
  buildPackages,
  targetPackages,
  stdenv,
  pkgs,
  # This is the default binutils, but with *this* version of LLD rather
  # than the default LLVM version's, if LLD is the choice. We use these for
  # the `useLLVM` bootstrapping below.
  bootBintoolsNoLibc ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintoolsNoLibc,
  bootBintools ? if stdenv.targetPlatform.linker == "lld" then null else pkgs.bintools,
  llvmVersions ? { },
  generateSplicesForMkScope,
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
    "21.1.8".officialRelease.sha256 = "sha256-pgd8g9Yfvp7abjCCKSmIn1smAROjqtfZaJkaUkBSKW0=";
    "22.1.0-rc2".officialRelease.sha256 = "sha256-j0KSuTANrwLh/siEcztSqCYQQDYHmdBCgVCsPsDCQ+I=";
    "23.0.0-git".gitRelease = {
      rev = "eae75353f70b01363bab9383da6b4dd4324d13a3";
      rev-version = "23.0.0-unstable-2026-01-25";
      sha256 = "sha256-04oX8cMoyXmqtwqMW2/xbtIhUQlgcM9AOO2bnhfx0zs=";
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
      lib.recurseIntoAttrs (
        callPackage ./common (
          {
            inherit (stdenvAdapters) overrideCC;
            inherit
              officialRelease
              gitRelease
              monorepoSrc
              version
              patchesFn
              bootBintools
              bootBintoolsNoLibc
              ;

            otherSplices = generateSplicesForMkScope "llvmPackages_${attrName}";
          }
          // packageSetArgs # Allow overrides.
        )
      )
    );

  llvmPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
llvmPackages // { inherit mkPackage versions; }
