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
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-/x8FqygivzddXsOwIV8aj/u+LPXMmokgu97vLAVEv80="
        else "sha256-3dTPIPGUeT6nb3gncNvEa4VTRyQIBJpp8oZadrT2ToE=";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = "8.72.0.17";
      jdkVersion = "8.0.382";
      hash =
        if enableJavaFX then "sha256-FkQ+0MzSZWUzc/HmiDVZEHGOrdKAVCdK5pm9wXXzzaU="
        else "sha256-rN5AI4xAWppE4kJlzMod0JmGyHdHjTXYtx8/wOW6CFk=";
    };
  }."${stdenv.hostPlatform.system}";

  jce-policies = fetchurl {
    url = "https://web.archive.org/web/20211126120343/http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    hash = "sha256-gCGii4ysQbRPFCH9IQoKCCL8r4jWLS5wo1sv9iioZ1o=";
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
      inherit (dist) hash;
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
