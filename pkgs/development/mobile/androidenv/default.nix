{
  config,
  pkgs ? import <nixpkgs> { },
  licenseAccepted ?
    config.android_sdk.accept_license or (builtins.getEnv "NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE" == "1"),
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
    includeEmulator =
      with pkgs.stdenv.hostPlatform;
      system == "x86_64-linux" || system == "x86_64-darwin" || system == "aarch64-darwin";
    includeSystemImages =
      with pkgs.stdenv.hostPlatform;
      system == "x86_64-linux" || system == "x86_64-darwin" || system == "aarch64-darwin";
    includeNDK =
      with pkgs.stdenv.hostPlatform;
      system == "x86_64-linux" || system == "x86_64-darwin" || system == "aarch64-darwin";
  };

  test-suite = pkgs.callPackage ./test-suite.nix { };

  meta = with pkgs.lib; {
    description = "Android SDK & sdkmanager";
    homepage = "https://developer.android.com/tools/sdkmanager";
    maintainers = with maintainers; [
      numinit
      hadilq
    ];
  };
}
