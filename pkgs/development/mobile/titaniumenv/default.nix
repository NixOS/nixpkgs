{pkgs, pkgs_i686, xcodeVersion ? "5.0", tiVersion ? "3.2.3.GA"}:

let
  # We have to use Oracle's JDK. On Darwin, just simply expose the host system's
  # JDK. According to their docs, OpenJDK is not supported.
  
  jdkWrapper = pkgs.stdenv.mkDerivation {
    name = "jdk-wrapper";
    buildCommand = ''
      mkdir -p $out/bin
      cd $out/bin
      ln -s /usr/bin/javac
      ln -s /usr/bin/java
      ln -s /usr/bin/jarsigner
      ln -s /usr/bin/jar
      ln -s /usr/bin/keytool
    '';
    setupHook = ''
      export JAVA_HOME=/usr
    '';
  };
in
rec {
  androidenv = pkgs.androidenv;

  xcodeenv = if pkgs.stdenv.system == "x86_64-darwin" then pkgs.xcodeenv.override {
    version = xcodeVersion;
  } else null;
  
  titaniumsdk = let
    titaniumSdkFile = if tiVersion == "3.1.4.GA" then ./titaniumsdk-3.1.nix
      else if tiVersion == "3.2.3.GA" then ./titaniumsdk-3.2.nix
      else if tiVersion == "3.3.0.GA" then ./titaniumsdk-3.3.nix
      else throw "Titanium version not supported: "+tiVersion;
    in
    import titaniumSdkFile {
      inherit (pkgs) stdenv fetchurl unzip makeWrapper python jdk;
    };
  
  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv python which;
    jdk = if pkgs.stdenv.isLinux then pkgs.oraclejdk7
      else if pkgs.stdenv.isDarwin then jdkWrapper
      else throw "Platform not supported: ${pkgs.stdenv.system}";
    inherit (pkgs.nodePackages) titanium;
    inherit (androidenv) androidsdk;
    inherit (xcodeenv) xcodewrapper;
    inherit titaniumsdk;
  };
}
