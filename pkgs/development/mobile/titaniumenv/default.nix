{pkgs, pkgs_i686, tiVersion ? "7.1.0.GA"}:

rec {
  androidenv = import ../../nix-androidenvtests/androidenv {
    inherit pkgs pkgs_i686;
  };

  xcodeenv = import ../../nix-xcodeenvtests/xcodeenv {
    inherit (pkgs) stdenv;
  };

  titaniumsdk = let
    titaniumSdkFile = if tiVersion == "7.1.0.GA" then ./titaniumsdk-7.1.nix
      else if tiVersion == "7.5.1.GA" then ./titaniumsdk-7.5.nix
      else throw "Titanium version not supported: "+tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs) stdenv fetchurl unzip makeWrapper;
    };

  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv python which file jdk nodejs;
    inherit (pkgs.nodePackages_8_x) alloy titanium;
    inherit (androidenv) composeAndroidPackages;
    inherit (xcodeenv) composeXcodeWrapper;
    inherit titaniumsdk;
  };
}
