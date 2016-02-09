{ stdenv, fetchurl, unzip, setJavaClassPath }:
let
  jdk = stdenv.mkDerivation {
    name = "zulu1.8.0_66-8.11.0.1";

    src = fetchurl {
      url = http://cdn.azulsystems.com/zulu/bin/zulu1.8.0_66-8.11.0.1-macosx.zip;
      sha256 = "0pvbpb3vf0509xm2x1rh0p0w4wmx50zf15604p28z1k8ai1a23sz";
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/zulu-linux/";
    };

    buildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out
      mv * $out

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/darwin/*_md.h $out/include/
    '';

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      echo -n "${setJavaClassPath}" > $out/nix-support/propagated-native-build-inputs

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
