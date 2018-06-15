{pkgs, pkgs_i686, xcodeVersion ? "9.2", xcodeBaseDir ? "/Applications/Xcode.app", tiVersion ? "7.1.0.GA"}:

rec {
  androidenv = pkgs.androidenv;

  xcodeenv = if pkgs.stdenv.system == "x86_64-darwin" then pkgs.xcodeenv.override {
    version = xcodeVersion;
    inherit xcodeBaseDir;
  } else null;
  
  titaniumsdk = let
    titaniumSdkFile = if tiVersion == "6.3.1.GA" then ./titaniumsdk-6.3.nix
      else if tiVersion == "7.1.0.GA" then ./titaniumsdk-7.1.nix
      else throw "Titanium version not supported: "+tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs) stdenv fetchurl unzip makeWrapper python jdk;
    };
  
  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv python which file jdk nodejs;
    inherit (pkgs.nodePackages_6_x) alloy titanium;
    inherit (androidenv) androidsdk;
    inherit (xcodeenv) xcodewrapper;
    inherit titaniumsdk xcodeBaseDir;
  };
}
