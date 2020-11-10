{ stdenv, fetchurl, unzip, setJavaClassPath, freetype }:
let
  jce-policies = fetchurl {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  jdk = stdenv.mkDerivation {
    # @hlolli: Later version than 1.8.0_202 throws error when building jvmci.
    # dyld: lazy symbol binding failed: Symbol not found: _JVM_BeforeHalt
    # Referenced from: ../libjava.dylib Expected in: .../libjvm.dylib
    name = "zulu1.8.0_202-8.36.0.1";

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu8.36.0.1-ca-jdk8.0.202-macosx_x64.zip";
      sha256 = "0s92l1wlf02vjx8dvrsla2kq7qwxnmgh325b38mgqy872016jm9p";
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
