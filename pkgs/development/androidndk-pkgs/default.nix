{ androidenv, buildPackages, pkgs, targetPackages
, includeSources ? true, licenseAccepted ? false
}:

rec {

  "17c" = import ./androidndk-pkgs.nix {
    inherit (buildPackages)
      makeWrapper;
    inherit (pkgs)
      lib stdenv
      runCommand wrapBintoolsWith wrapCCWith;
    # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
    # but for splicing messing up on infinite recursion for the variants we
    # *dont't* use. Using this workaround, but also making a test to ensure
    # these two really are the same.
    buildAndroidndk = buildPackages.buildPackages.androidenv.androidndk_17c;
    androidndk = androidenv.androidndk_17c;
    targetAndroidndkPkgs = targetPackages.androidndkPkgs_17c;
  };

  "10e" = import ./androidndk-pkgs.nix {
    inherit (buildPackages)
      makeWrapper;
    inherit (pkgs)
      lib stdenv
      runCommand wrapBintoolsWith wrapCCWith;
    # buildPackages.foo rather than buildPackages.buildPackages.foo would work,
    # but for splicing messing up on infinite recursion for the variants we
    # *dont't* use. Using this workaround, but also making a test to ensure
    # these two really are the same.
    buildAndroidndk = buildPackages.buildPackages.androidenv.androidndk_10e;
    androidndk = androidenv.androidndk_10e;
    targetAndroidndkPkgs = targetPackages.androidndkPkgs_10e;
  };
}
