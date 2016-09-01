{pkgs, pkgs_i686, xcodeVersion ? "7.2", xcodeBaseDir ? "/Applications/Xcode.app", tiVersion ? "5.2.3.GA"}:

rec {
  androidenv = pkgs.androidenv;

  xcodeenv = if pkgs.stdenv.system == "x86_64-darwin" then pkgs.xcodeenv.override {
    version = xcodeVersion;
    inherit xcodeBaseDir;
  } else null;
  
  titaniumsdk = let
    titaniumSdkFile = if tiVersion == "5.1.2.GA" then ./titaniumsdk-5.1.nix
      else if tiVersion == "5.2.3.GA" then ./titaniumsdk-5.2.nix
      else throw "Titanium version not supported: "+tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs) stdenv fetchurl unzip makeWrapper python jdk;
    };
  
  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv python which jdk nodejs;
    inherit (pkgs.nodePackages) titanium alloy;
    inherit (androidenv) androidsdk;
    inherit (xcodeenv) xcodewrapper;
    inherit titaniumsdk xcodeBaseDir;
  };
}
