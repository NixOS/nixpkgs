{ lib, androidenv, buildPackages, pkgs, targetPackages
}:

let
  makeNdkPkgs = ndkVersion:
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
  "21" = makeNdkPkgs "21.0.6113669";
  "23b" = makeNdkPkgs "23.1.7779620";
  "24" = makeNdkPkgs "24.0.8215888";
  "25" = makeNdkPkgs "25.2.9519653";
  "26" = makeNdkPkgs "26.3.11579264";
}
