<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, unzip
, setJavaClassPath
, enableJavaFX ? false
}:
=======
{ lib, stdenv, fetchurl, unzip, setJavaClassPath }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  # Details from https://www.azul.com/downloads/?version=java-19-sts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
<<<<<<< HEAD
      zuluVersion = if enableJavaFX then "19.32.15" else "19.32.13";
      jdkVersion = "19.0.2";
      hash =
        if enableJavaFX then "sha256-AwLcIId0gH5D6DUU8CgJ3qnKVQm28LXYirBeXBHwPYE="
        else "sha256-KARXWumsY+OcqpEOV2EL9SsPni1nGSipjRji/Mn2KsE=";
=======
      zuluVersion = "19.30.11";
      jdkVersion = "19.0.1";
      sha256 = "1h0qj0xgpxjy506ikbgdn74pi4860lsnh5n3q3bayfmn0pxc5ksn";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    aarch64-darwin = {
      arch = "aarch64";
<<<<<<< HEAD
      zuluVersion = if enableJavaFX then "19.32.15" else "19.32.13";
      jdkVersion = "19.0.2";
      hash =
        if enableJavaFX then "sha256-/R2rrcBr64qPGEtvhruXBhPwnvurt/hiR1ICzZAdYxE="
        else "sha256-F30FjZaLL756X/Xs6xjNwW9jds4pEATxoxOeeLL7Y5E=";
=======
      zuluVersion = "19.30.11";
      jdkVersion = "19.0.1";
      sha256 = "0g8i371h5fv686xhiff0431sgvdk80lbp2lkz86jpfdv9lgg0qnk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  }."${stdenv.hostPlatform.system}";

  jce-policies = fetchurl {
<<<<<<< HEAD
    url = "https://web.archive.org/web/20211126120343/http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    hash = "sha256-gCGii4ysQbRPFCH9IQoKCCL8r4jWLS5wo1sv9iioZ1o=";
  };

  javaPackage = if enableJavaFX then "ca-fx-jdk" else "ca-jdk";

  jdk = stdenv.mkDerivation rec {
    pname = "zulu${dist.zuluVersion}-${javaPackage}";
    version = dist.jdkVersion;

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu${dist.zuluVersion}-${javaPackage}${dist.jdkVersion}-macosx_${dist.arch}.tar.gz";
      inherit (dist) hash;
=======
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  jdk = stdenv.mkDerivation rec {
    pname = "zulu${dist.zuluVersion}-ca-jdk";
    version = dist.jdkVersion;

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu${dist.zuluVersion}-ca-jdk${dist.jdkVersion}-macosx_${dist.arch}.tar.gz";
      inherit (dist) sha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/";
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out
      mv * $out

      unzip ${jce-policies}
      mv -f ZuluJCEPolicies/*.jar $out/lib/security/

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/darwin/*_md.h $out/include/

      if [ -f $out/LICENSE ]; then
        install -D $out/LICENSE $out/share/zulu/LICENSE
        rm $out/LICENSE
      fi
    '';

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JDK so that
      # any package that depends on the JDK has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    # fixupPhase is moving the man to share/man which breaks it because it's a
    # relative symlink.
    postFixup = ''
      ln -nsf ../zulu-${lib.versions.major version}.jdk/Contents/Home/man $out/share/man
    '';

    passthru = {
      home = jdk;
    };

    meta = import ./meta.nix lib version;
  };
in
jdk
