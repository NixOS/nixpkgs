{ lib, androidenv, buildPackages, pkgs, targetPackages
}:

{
  "21" =
    let
      ndkVersion = "21.0.6113669";

      buildAndroidComposition = buildPackages.buildPackages.androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };

      androidComposition = androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };
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
      targetAndroidndkPkgs = if targetPackages ? androidndkPkgs_21 then targetPackages.androidndkPkgs_21 else throw "androidndkPkgs_21: no targetPackages, use `buildPackages.androidndkPkgs_21";
    };

  "23b" =
    let
      ndkVersion = "23.1.7779620";

      buildAndroidComposition = buildPackages.buildPackages.androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };

      androidComposition = androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };
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
      targetAndroidndkPkgs = if targetPackages ? androidndkPkgs_23b then targetPackages.androidndkPkgs_23b else throw "androidndkPkgs_23b: no targetPackages, use `buildPackages.androidndkPkgs_23b";
    };

  "24" =
    let
      ndkVersion = "24.0.8215888";

      buildAndroidComposition = buildPackages.buildPackages.androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };

      androidComposition = androidenv.composeAndroidPackages {
        includeNDK = true;
        inherit ndkVersion;
      };
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
      targetAndroidndkPkgs = if targetPackages ? androidndkPkgs_24 then targetPackages.androidndkPkgs_24 else throw "androidndkPkgs_24: no targetPackages, use `buildPackages.androidndkPkgs_24";
    };

}
