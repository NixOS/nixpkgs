{
  pkgs,
  androidenv,
  xcodeenv,
  tiVersion ? "8.3.2.GA",
}:

rec {
  titaniumsdk =
    let
      titaniumSdkFile =
        if tiVersion == "8.2.1.GA" then
          ./titaniumsdk-8.2.nix
        else if tiVersion == "8.3.2.GA" then
          ./titaniumsdk-8.3.nix
        else
          throw "Titanium version not supported: " + tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs)
        stdenv
        lib
        fetchurl
        unzip
        makeWrapper
        ;
    };

  buildApp = import ./build-app.nix {
    inherit (pkgs)
      stdenv
      lib
      python
      which
      file
      jdk
      nodejs
      titanium
      ;
    alloy = pkgs.titanium-alloy;
    inherit (androidenv) composeAndroidPackages;
    inherit (xcodeenv) composeXcodeWrapper;
    inherit titaniumsdk;
  };
}
