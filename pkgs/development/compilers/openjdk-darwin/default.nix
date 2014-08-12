{ stdenv, fetchurl, unzip, setJavaClassPath }:
let
  jdk = stdenv.mkDerivation {
    name = "openjdk-7u60b30";

    # From https://github.com/alexkasko/openjdk-unofficial-builds
    src = fetchurl {
      url = https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u60-unofficial-macosx-x86_64-bundle.zip;
      sha256 = "af510a4d566712d82c17054bb39f91d98c69a85586e244c6123669a0bd4b7401";
    };

    buildInputs = [ unzip ];

    installPhase = ''
      mv */Contents/Home $out

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

    passthru.jre = jdk;

  };
in jdk
