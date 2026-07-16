{
  lib,
  pkgs ? import <nixpkgs> { },
  licenseAccepted ? pkgs.callPackage ./license.nix { },
}:

lib.recurseIntoAttrs rec {
  composeAndroidPackages = pkgs.callPackage ./compose-android-packages.nix {
    inherit licenseAccepted meta;
  };

  buildApp = pkgs.callPackage ./build-app.nix {
    inherit composeAndroidPackages meta;
  };

  emulateApp = pkgs.callPackage ./emulate-app.nix {
    inherit composeAndroidPackages meta;
  };

  androidPkgs = composeAndroidPackages {
    # Support roughly the last 5 years of Android packages and system images by default in nixpkgs.
    numLatestPlatformVersions = 5;
    includeEmulator = "if-supported";
    includeSystemImages = "if-supported";
    includeNDK = "if-supported";
  };

  test-suite = pkgs.callPackage ./test-suite.nix {
    inherit meta;
  };

  inherit (test-suite) passthru;

  meta = {
    homepage = "https://developer.android.com/tools";
    description = "Android SDK tools, packaged in Nixpkgs";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    teams = [ lib.teams.android ];
  };
}
