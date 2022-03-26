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
      zuluVersion = "8.54.0.21";
      jdkVersion = "8.0.292";
      sha256 =
        if enableJavaFX then "e671f8990229b1ca2a76faabb21ba2f1a9e1f7211392e0f657225559be9b05c8"
        else "1pgl0bir4r5v349gkxk54k6v62w241q7vw4gjxhv2g6pfq6hv7in";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = "8.54.0.21";
      jdkVersion = "8.0.292";
      sha256 =
        if enableJavaFX then "8e901075cde2c31f531a34e8321ea4201970936abf54240a232e9389952afe84"
        else "05w89wfjlfbpqfjnv6wisxmaf13qb28b2223f9264jyx30qszw1c";
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

    passthru = {
      jre = jdk;
      home = jdk;
    };

    meta = import ./meta.nix lib;
  };
in
jdk
