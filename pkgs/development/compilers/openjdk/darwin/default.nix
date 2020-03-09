{ stdenv, fetchurl, unzip, setJavaClassPath, freetype }:
let
  jce-policies = fetchurl {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  jdk = stdenv.mkDerivation rec {
    name = "zulu13.28.11-ca-jdk13.0.1";

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/${name}-macosx_x64.tar.gz";
      sha256 = "0j148gq7vwhda6y9sazy0qg6ka7milywrdhbvmd31a1xp303r37b";
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/";
    };

    buildInputs = [ unzip freetype ];

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

      install_name_tool -change /usr/X11/lib/libfreetype.6.dylib ${freetype}/lib/libfreetype.6.dylib $out/lib/libfontmanager.dylib

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    passthru = {
      home = jdk;
    };

    meta = with stdenv.lib; {
      license = licenses.gpl2;
      platforms = platforms.darwin;
    };

  };
in jdk
