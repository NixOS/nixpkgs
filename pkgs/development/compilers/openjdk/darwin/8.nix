{ lib
, stdenv
, fetchurl
, unzip
, setJavaClassPath
, enableJavaFX ? false
}:
let
  # Details from https://www.azul.com/downloads/?version=java-8-lts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
      zuluVersion = "8.68.0.21";
      jdkVersion = "8.0.362";
      sha256 =
        if enableJavaFX then "0kscvpkimxn3x8nq3vzwfni1g0dz0hr7n8s54d15vh7ajhfrizz6"
        else "06gnpa9b909aafkhmra1bjw8sa4qsw3934px9nrkrwfbfsbhy84v";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = "8.68.0.21";
      jdkVersion = "8.0.362";
      sha256 =
        if enableJavaFX then "0y7hnfk1db2z8pxvrr6dakiy2w1g7dlknssk3zk4fp7lay6vdl3y"
        else "0m1lflgv12sslafsn0vvjqdnx7d1gi9pgkxx26k4z9zvjiqklsgl";
    };
  }."${stdenv.hostPlatform.system}";

  jce-policies = fetchurl {
    url = "https://web.archive.org/web/20211126120343/http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  javaPackage = if enableJavaFX then "ca-fx-jdk" else "ca-jdk";

  jdk = stdenv.mkDerivation rec {
    # @hlolli: Later version than 1.8.0_202 throws error when building jvmci.
    # dyld: lazy symbol binding failed: Symbol not found: _JVM_BeforeHalt
    # Referenced from: ../libjava.dylib Expected in: .../libjvm.dylib
    pname = "zulu${dist.zuluVersion}-${javaPackage}";
    version = dist.jdkVersion;

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu${dist.zuluVersion}-${javaPackage}${dist.jdkVersion}-macosx_${dist.arch}.tar.gz";
      inherit (dist) sha256;
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/";
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out
      mv * $out

      unzip ${jce-policies}
      mv -f ZuluJCEPolicies/*.jar $out/jre/lib/security/

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/darwin/*_md.h $out/include/

      if [ -f $out/LICENSE ]; then
        install -D $out/LICENSE $out/share/zulu/LICENSE
        rm $out/LICENSE
      fi
    '';

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
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
      jre = jdk;
      home = jdk;
    };

    meta = import ./meta.nix lib version;
  };
in
jdk
