{ stdenv, fetchurl, unzip, setJavaClassPath, freetype }:
let
  jce-policies = fetchurl {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  jdk = stdenv.mkDerivation {
    name = "zulu1.8.0_222-8.40.0.25-ca-fx";

    src = fetchurl {
      url = "http://cdn.azul.com/zulu/bin/zulu8.40.0.25-ca-fx-jdk8.0.222-macosx_x64.zip";
      sha256 = "1mal8bdc94q7ahx7p3xggy3qpxr6h83g2y01wzgvnqjd8n5i3qr1";
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

      install_name_tool -change /usr/X11/lib/libfreetype.6.dylib ${freetype}/lib/libfreetype.6.dylib $out/jre/lib/libfontmanager.dylib

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    passthru = {
      jre = jdk;
      home = jdk;
    };

    meta = with stdenv.lib; {
      license = licenses.gpl2;
      platforms = platforms.darwin;
    };

  };
in jdk
