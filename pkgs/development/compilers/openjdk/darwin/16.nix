{ lib
, stdenv
, fetchurl
, unzip
, setJavaClassPath
, enableJavaFX ? false
}:
let
  # Details from https://www.azul.com/downloads/?version=java-16-sts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
<<<<<<< HEAD
      zuluVersion = "16.32.15";
      jdkVersion = "16.0.2";
      hash =
        if enableJavaFX then "sha256-6URaSBNHQWLauO//kCuKXb4Z7AqyshWnoeJEyVRKgaY="
        else "sha256-NXgBj/KixTknaCYbo3B+rOo11NImH5CDUIU0LhTCtMo=";
=======
      zuluVersion = "16.30.15";
      jdkVersion = "16.0.1";
      sha256 =
        if enableJavaFX then "cbb3b96d80a0675893f21dc51ba3f532049c501bd7dc4c8d1ee930e63032c745"
        else "1jihn125dmxr9y5h9jq89zywm3z6rbwv5q7msfzsf2wzrr13jh0z";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    aarch64-darwin = {
      arch = "aarch64";
<<<<<<< HEAD
      zuluVersion = "16.32.15";
      jdkVersion = "16.0.2";
      hash =
        if enableJavaFX then "sha256-QuyhIAxUY3Vv1adGihW+LIsXtpDX2taCmFsMFj9o5vs="
        else "sha256-3bUfDcLLyahLeURFAgLAVapBZHvqtam8GHbWTA6MQog=";
=======
      zuluVersion = "16.30.19";
      jdkVersion = "16.0.1";
      sha256 =
        if enableJavaFX then "a49b23abfd83784d2ac935fc24e25ab7cb09b8ffc8e47c32ed446e05b8a21396"
        else "1i0bcjx3acb5dhslf6cabdcnd6mrz9728vxw9hb4al5y3f5fll4w";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  }."${stdenv.hostPlatform.system}";

  jce-policies = fetchurl {
    url = "https://web.archive.org/web/20211126120343/http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
<<<<<<< HEAD
    hash = "sha256-gCGii4ysQbRPFCH9IQoKCCL8r4jWLS5wo1sv9iioZ1o=";
=======
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  javaPackage = if enableJavaFX then "ca-fx-jdk" else "ca-jdk";

  jdk = stdenv.mkDerivation rec {
    pname = "zulu${dist.zuluVersion}-${javaPackage}";
    version = dist.jdkVersion;

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu${dist.zuluVersion}-${javaPackage}${dist.jdkVersion}-macosx_${dist.arch}.tar.gz";
<<<<<<< HEAD
      inherit (dist) hash;
=======
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
