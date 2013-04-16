{pkgs, pkgs_i686, version ? "3.1"}:

let
  titaniumexpr = if version == "2.1" then
    ./titaniumsdk-2.1.nix
  else if version == "3.1" then
    ./titaniumsdk.nix
  else
    throw "Unknown Titanium SDK version: ${version}";
in
rec {
  androidenv = pkgs.androidenv;

  xcodeenv = if pkgs.stdenv.system == "x86_64-darwin" then pkgs.xcodeenv else null;
  
  titaniumsdk = import titaniumexpr {
    inherit (pkgs) stdenv fetchurl unzip makeWrapper python jdk;
  };
  
  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv;
    inherit (androidenv) androidsdk;
    inherit (xcodeenv) xcodewrapper;
    inherit titaniumsdk;
  };
}
