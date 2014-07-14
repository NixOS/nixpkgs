{ stdenv, fetchurl, setJavaClassPath }:
let
  jdk = stdenv.mkDerivation {
    name = "openjdk6-b16-24_apr_2009-r1";

    src = fetchurl {
      url = http://landonf.bikemonkey.org/static/soylatte/bsd-dist/openjdk6_darwin/openjdk6-b16-24_apr_2009-r1.tar.bz2;
      sha256 = "14pbv6jjk95k7hbgiwyvjdjv8pccm7m8a130k0q7mjssf4qmpx1v";
    };

    installPhase = ''
      mkdir -p $out
      cp -vR * $out/

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
      mkdir -p $out/nix-support
      cat <<EOF > $out/nix-support/setup-hook
      if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    passthru.jre = jdk;

  };
in jdk
