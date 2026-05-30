{
  lib,
  androidenv,
  buildPackages,
  pkgs,
  targetPackages,
  config,
}:

let
  makeNdkPkgs =
    ndkVersion: llvmPackages:
    let
      buildAndroidComposition = buildPackages.buildPackages.androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };

      androidComposition = androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };
      majorVersion = lib.versions.major ndkVersion;
    in
    import ./androidndk-pkgs.nix {
      inherit config lib;
      inherit (buildPackages)
        makeWrapper
        autoPatchelfHook
        ;
      inherit (pkgs)
        stdenv
        runCommand
        wrapBintoolsWith
        wrapCCWith
        ;

      # For hardeningUnsupportedFlagsByTargetPlatform
      inherit llvmPackages;

      # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
      # but for splicing messing up on infinite recursion for the variants we
      # *dont't* use. Using this workaround, but also making a test to ensure
      # these two really are the same.
      buildAndroidndk = buildAndroidComposition.ndk-bundle;
      androidndk = androidComposition.ndk-bundle;
      targetAndroidndkPkgs =
        if targetPackages ? "androidndkPkgs_${majorVersion}" then
          targetPackages."androidndkPkgs_${majorVersion}"
        else
          throw "androidndkPkgs_${majorVersion}: no targetPackages, use `buildPackages.androidndkPkgs_${majorVersion}";
    };
in

lib.recurseIntoAttrs {
  "27" = makeNdkPkgs "27.0.12077973" pkgs.llvmPackages_18;
  "28" = makeNdkPkgs "28.0.13004108" pkgs.llvmPackages_19;
  "29" = makeNdkPkgs "29.0.14206865" pkgs.llvmPackages_21;
}
