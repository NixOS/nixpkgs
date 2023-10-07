{ config, pkgs ? import <nixpkgs> {}
, licenseAccepted ? config.android_sdk.accept_license or (builtins.getEnv "NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE" == "1")
}:

rec {
  composeAndroidPackages = pkgs.callPackage ./compose-android-packages.nix {
    inherit licenseAccepted;
  };

  buildApp = pkgs.callPackage ./build-app.nix {
    inherit composeAndroidPackages;
  };

  emulateApp = pkgs.callPackage ./emulate-app.nix {
    inherit composeAndroidPackages;
  };

  androidPkgs_9_0 = composeAndroidPackages {
    platformVersions = [ "28" ];
    abiVersions = [ "x86" "x86_64"];
  };

  test-suite = pkgs.callPackage ./test-suite.nix {};
}
