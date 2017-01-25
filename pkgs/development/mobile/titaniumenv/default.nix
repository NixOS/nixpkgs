{pkgs, pkgs_i686, xcodeVersion ? "8.2.1", xcodeBaseDir ? "/Applications/Xcode.app", tiVersion ? "6.0.2.GA"}:

rec {
  androidenv = pkgs.androidenv;

  xcodeenv = if pkgs.stdenv.system == "x86_64-darwin" then pkgs.xcodeenv.override {
    version = xcodeVersion;
    inherit xcodeBaseDir;
  } else null;
  
  titaniumsdk = let
    titaniumSdkFile = if tiVersion == "5.1.2.GA" then ./titaniumsdk-5.1.nix
      else if tiVersion == "5.2.3.GA" then ./titaniumsdk-5.2.nix
      else if tiVersion == "6.0.2.GA" then ./titaniumsdk-6.0.nix
      else throw "Titanium version not supported: "+tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs) stdenv fetchurl unzip makeWrapper python jdk;
    };
  
  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv python which jdk nodejs;
    inherit (pkgs.nodePackages_4_x) titanium alloy;
    inherit (androidenv) androidsdk;
    inherit (xcodeenv) xcodewrapper;
    inherit titaniumsdk xcodeBaseDir;
  };
}
