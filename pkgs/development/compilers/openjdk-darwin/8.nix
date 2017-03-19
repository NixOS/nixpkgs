{ stdenv, fetchurl, unzip, setJavaClassPath, freetype }:
let
  jce-policies = fetchurl {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  jdk = stdenv.mkDerivation {
    name = "zulu1.8.0_66-8.11.0.1";

    src = fetchurl {
      url = "http://cdn.azulsystems.com/zulu/bin/zulu1.8.0_66-8.11.0.1-macosx.zip";
      sha256 = "0pvbpb3vf0509xm2x1rh0p0w4wmx50zf15604p28z1k8ai1a23sz";
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/zulu-linux/";
    };

    buildInputs = [ unzip freetype ];

    installPhase = ''
      mkdir -p $out
      mv * $out

      unzip ${jce-policies}
      mv -f ZuluJCEPolicies/*.jar $out/jre/lib/security/

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/darwin/*_md.h $out/include/
    '';

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      echo -n "${setJavaClassPath}" > $out/nix-support/propagated-native-build-inputs

      install_name_tool -change /usr/X11/lib/libfreetype.6.dylib ${freetype}/lib/libfreetype.6.dylib $out/jre/lib/libfontmanager.dylib

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    passthru = {
      jre = jdk;
      home = jdk;
    };

    meta.platforms = stdenv.lib.platforms.darwin;

  };
in jdk
