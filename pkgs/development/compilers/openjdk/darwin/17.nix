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
  # Details from https://www.azul.com/downloads/?version=java-17-lts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
<<<<<<< HEAD
      zuluVersion = "17.44.15";
      jdkVersion = "17.0.8";
      hash =
        if enableJavaFX then "sha256-gmDku/AkWzO+eDRitezM9wCtTYDrUMtXyMulxqi9tNI="
        else "sha256-Ci18gBkAv/UUIQw9KlnfibcQMXwQRGx6K7L/NBB7b7Q=";
=======
      zuluVersion = "17.34.19";
      jdkVersion = "17.0.3";
      sha256 = "sha256-qImyxVC2y2QhxuVZwamKPyo46+n+7ytIFXpYI0e6w2c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    aarch64-darwin = {
      arch = "aarch64";
<<<<<<< HEAD
      zuluVersion = "17.44.15";
      jdkVersion = "17.0.8";
      hash =
        if enableJavaFX then "sha256-mvyfqpnAoA05HJB9EBewW2MDuhQBOvp6svzyayV1irI="
        else "sha256-8b81QY6DGXVOsTKM8QDzJnYjXV0ipCbYWaaz6oF2A6k=";
=======
      zuluVersion = "17.34.19";
      jdkVersion = "17.0.3";
      sha256 = "sha256-eaRX8Qa/Mqr9JhpHSEcf0Q9c4qmqLMgWqRhkEEwAjf8=";
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
