{ lib, androidenv, buildPackages, pkgs, targetPackages, androidndkPkgs_23, config
}:

let
  makeNdkPkgs = ndkVersion: llvmPackages:
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
      inherit lib;
      inherit (buildPackages)
        makeWrapper autoPatchelfHook;
      inherit (pkgs)
        stdenv
        runCommand wrapBintoolsWith wrapCCWith;

      # For hardeningUnsupportedFlagsByTargetPlatform
      inherit llvmPackages;

      # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
      # but for splicing messing up on infinite recursion for the variants we
      # *dont't* use. Using this workaround, but also making a test to ensure
      # these two really are the same.
      buildAndroidndk = buildAndroidComposition.ndk-bundle;
      androidndk = androidComposition.ndk-bundle;
      targetAndroidndkPkgs = if targetPackages ? "androidndkPkgs_${majorVersion}" then targetPackages."androidndkPkgs_${majorVersion}" else throw "androidndkPkgs_${majorVersion}: no targetPackages, use `buildPackages.androidndkPkgs_${majorVersion}";
    };
in

{
  "21" = makeNdkPkgs "21.0.6113669" pkgs.llvmPackages_14; # "9"
  "23" = makeNdkPkgs "23.1.7779620" pkgs.llvmPackages_14; # "12"
  # Versions below 24 use a version not available in nixpkgs/old version which could be removed in the near future so use 14 for them as this is only used to get the hardening flags.
  "24" = makeNdkPkgs "24.0.8215888" pkgs.llvmPackages_14;
  "25" = makeNdkPkgs "25.2.9519653" pkgs.llvmPackages_14;
  "26" = makeNdkPkgs "26.3.11579264" pkgs.llvmPackages_17;
}
