{pkgs, androidenv, xcodeenv, tiVersion ? "8.3.2.GA"}:

rec {
  titaniumsdk = let
    titaniumSdkFile = if tiVersion == "8.2.1.GA" then ./titaniumsdk-8.2.nix
      else if tiVersion == "7.5.1.GA" then ./titaniumsdk-7.5.nix
      else if tiVersion == "8.3.2.GA" then ./titaniumsdk-8.3.nix
      else throw "Titanium version not supported: "+tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs) stdenv lib fetchurl unzip makeWrapper;
    };

  buildApp = import ./build-app.nix {
<<<<<<< HEAD
    inherit (pkgs) stdenv lib python which file jdk nodejs titanium;
    alloy = pkgs.titanium-alloy;
=======
    inherit (pkgs) stdenv lib python which file jdk nodejs;
    inherit (pkgs.nodePackages) alloy titanium;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit (androidenv) composeAndroidPackages;
    inherit (xcodeenv) composeXcodeWrapper;
    inherit titaniumsdk;
  };
}
