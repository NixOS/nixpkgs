{
  config,
  pkgs ? import <nixpkgs> { },
  licenseAccepted ?
    config.android_sdk.accept_license or (builtins.getEnv "NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE" == "1"),
}:

let
  inherit (pkgs) lib;
in

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

  androidPkgs = composeAndroidPackages {
    platformVersions = [
      "28"
      "29"
      "30"
      "31"
      "32"
      "33"
      "34"
      "35"
    ];
    includeEmulator = true;
    includeSystemImages = true;
    includeNDK = true;
  };

  test-suite = pkgs.callPackage ./test-suite.nix { };

  meta = {
    description = "Android SDK & sdkmanager";
    homepage = "https://developer.android.com/tools/sdkmanager";
    maintainers = with lib.maintainers; [
      numinit
      hadilq
    ];
  };
}
