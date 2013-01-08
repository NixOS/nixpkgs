{pkgs, pkgs_i686}:

rec {
  androidenv = pkgs.androidenv;

  xcodeenv = if pkgs.stdenv.system == "x86_64-darwin" then pkgs.xcodeenv else null;

  titaniumsdk = import ./titaniumsdk.nix {
    inherit (pkgs) stdenv fetchurl unzip makeWrapper python jdk;
  };
  
  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv;
    inherit (androidenv) androidsdk;
    inherit (xcodeenv) xcodewrapper;
    inherit titaniumsdk;
  };
}
