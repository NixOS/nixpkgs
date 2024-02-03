{ lib
, stdenv
, fetchurl
, setJavaClassPath
, enableJavaFX ? false
, dists
  # minimum dependencies
, unzip
, autoPatchelfHook
, makeWrapper
, alsa-lib
, fontconfig
, freetype
, zlib
, xorg
  # runtime dependencies
, cups
  # runtime dependencies for GTK+ Look and Feel
, gtkSupport ? stdenv.isLinux
, cairo
, glib
, gtk3
}:
let
  dist = dists.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  arch = {
    "aarch64" = "aarch64";
    "x86_64" = "x64";
  }.${stdenv.hostPlatform.parsed.cpu.name}
    or (throw "Unsupported architecture: ${stdenv.hostPlatform.parsed.cpu.name}");

  platform = {
    "darwin" = "macosx";
    "linux" = "linux";
  }.${stdenv.hostPlatform.parsed.kernel.name}
    or (throw "Unsupported platform: ${stdenv.hostPlatform.parsed.kernel.name}");

  runtimeDependencies = [
    cups
  ] ++ lib.optionals gtkSupport [
    cairo
    glib
    gtk3
  ];

  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;

  jce-policies = fetchurl {
    url = "https://web.archive.org/web/20211126120343/http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip";
    hash = "sha256-gCGii4ysQbRPFCH9IQoKCCL8r4jWLS5wo1sv9iioZ1o=";
  };

  javaPackage = if enableJavaFX then "ca-fx-jdk" else "ca-jdk";

  isJdk8 = lib.versions.major dist.jdkVersion == "8";

  jdk = stdenv.mkDerivation rec {
    pname = "zulu-${javaPackage}";
    version = dist.jdkVersion;

    src = fetchurl {
      url = "https://cdn.azul.com/zulu/bin/zulu${dist.zuluVersion}-${javaPackage}${dist.jdkVersion}-${platform}_${arch}.tar.gz";
      inherit (dist) hash;
      curlOpts = "-H Referer:https://www.azul.com/downloads/zulu/";
    };

    nativeBuildInputs = [
      unzip
    ] ++ lib.optionals stdenv.isLinux [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = lib.optionals stdenv.isLinux [
      alsa-lib # libasound.so wanted by lib/libjsound.so
      fontconfig
      freetype
      stdenv.cc.cc # libstdc++.so.6
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      zlib
    ];

    installPhase = ''
      mkdir -p $out
      mv * $out

      unzip ${jce-policies}
      mv -f ZuluJCEPolicies/*.jar $out/${lib.optionalString isJdk8 "jre/"}lib/security/

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/${stdenv.hostPlatform.parsed.kernel.name}/*_md.h $out/include/

      if [ -f $out/LICENSE ]; then
        install -D $out/LICENSE $out/share/zulu/LICENSE
        rm $out/LICENSE
      fi
    '';

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the ${if isJdk8 then "JRE" else "JDK"} so that
      # any package that depends on the ${if isJdk8 then "JRE" else "JDK"} has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '' + lib.optionalString stdenv.isLinux ''
      # We cannot use -exec since wrapProgram is a function but not a command.
      #
      # jspawnhelper is executed from JVM, so it doesn't need to wrap it, and it
      # breaks building OpenJDK (#114495).
      for bin in $( find "$out" -executable -type f -not -name jspawnhelper ); do
        if patchelf --print-interpreter "$bin" &> /dev/null; then
          wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
        fi
      done
    ''
    # FIXME: move all of the above to installPhase.
    + lib.optionalString stdenv.isLinux ''
      find "$out" -name libfontmanager.so -exec \
        patchelf --add-needed libfontconfig.so {} \;
    '';

    # fixupPhase is moving the man to share/man which breaks it because it's a
    # relative symlink.
    postFixup = lib.optionalString stdenv.isDarwin ''
      ln -nsf ../zulu-${lib.versions.major version}.jdk/Contents/Home/man $out/share/man
    '';

    passthru = (lib.optionalAttrs isJdk8 {
      jre = jdk;
    }) // {
      home = jdk;
    };

    meta = (import ../openjdk/meta.nix lib version) // {
      description = "Certified builds of OpenJDK";
      longDescription = ''
        Certified builds of OpenJDK that can be deployed across multiple
        operating systems, containers, hypervisors and Cloud platforms.
      '';
      homepage = "https://www.azul.com/products/zulu/";
      mainProgram = "java";
      maintainers = [ ];
      platforms = builtins.attrNames dists;
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode binaryNativeCode ];
    };
  };
in
jdk
