{ lib, stdenv, fetchurl, unzip, setJavaClassPath, freetype }:
let
  jce-policies = fetchurl {
    # Ugh, unversioned URLs... I hope this doesn't change often enough to cause pain before we move to a Darwin source build of OpenJDK!
    url    = "http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    sha256 = "0nk7m0lgcbsvldq2wbfni2pzq8h818523z912i7v8hdcij5s48c0";
  };

  jdk = stdenv.mkDerivation rec {
    name = "zulu11.43.21-ca-jdk11.0.9";

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/${name}-macosx_x64.tar.gz";
      sha256 = "1j19fb5mwdkfn6y8wfsnvxsz6wfpcab4xv439fqssxy520n6q4zs";
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/zulu-mac/";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs = [ freetype ];

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

    # fixupPhase is moving the man to share/man which breaks it because it's a
    # relative symlink.
    postFixup = ''
      ln -nsf ../zulu-11.jdk/Contents/Home/man $out/share/man
    '';

    passthru = {
      home = jdk;
    };

    meta = with lib; {
      license = licenses.gpl2;
      platforms = platforms.darwin;
    };

  };
in jdk
