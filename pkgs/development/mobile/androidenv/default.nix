{ config, pkgs ? import <nixpkgs> {}, pkgsHostHost ? pkgs.pkgsHostHost
, pkgs_i686 ? import <nixpkgs> { system = "i686-linux"; }
, licenseAccepted ? config.android_sdk.accept_license or false
}:

rec {
  composeAndroidPackages = import ./compose-android-packages.nix {
    inherit (pkgs) requireFile autoPatchelfHook;
    inherit pkgs pkgsHostHost pkgs_i686 licenseAccepted;
  };

  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv lib jdk ant gnumake gawk;
    inherit composeAndroidPackages;
  };

  emulateApp = import ./emulate-app.nix {
    inherit (pkgs) stdenv lib runtimeShell;
    inherit composeAndroidPackages;
  };

  androidPkgs_9_0 = composeAndroidPackages {
    platformVersions = [ "28" ];
    abiVersions = [ "x86" "x86_64"];
  };
}
