{
  sourcePerArch,
  knownVulnerabilities ? [ ],
}:

{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  setJavaClassPath,
  # minimum dependencies
  alsa-lib,
  fontconfig,
  freetype,
  libffi,
  xorg,
  zlib,
  # runtime dependencies
  cups,
  # runtime dependencies for GTK+ Look and Feel
  gtkSupport ? true,
  cairo,
  glib,
  gtk3,
}:

let
  cpuName = stdenv.hostPlatform.parsed.cpu.name;
  runtimeDependencies =
    [
      cups
    ]
    ++ lib.optionals gtkSupport [
      cairo
      glib
      gtk3
    ];
  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;
in

let
  result = stdenv.mkDerivation rec {
    pname =
      if sourcePerArch.packageType == "jdk" then
        "adoptopenjdk-${sourcePerArch.vmType}-bin"
      else
        "adoptopenjdk-${sourcePerArch.packageType}-${sourcePerArch.vmType}-bin";

    version = sourcePerArch.${cpuName}.version or (throw "unsupported CPU ${cpuName}");

    src = fetchurl {
      inherit (sourcePerArch.${cpuName}) url sha256;
    };

    buildInputs = [
      alsa-lib # libasound.so wanted by lib/libjsound.so
      fontconfig
      freetype
      stdenv.cc.cc.lib # libstdc++.so.6
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      zlib
    ] ++ lib.optional stdenv.isAarch32 libffi;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    # See: https://github.com/NixOS/patchelf/issues/10
    dontStrip = 1;

    installPhase = ''
      cd ..

      mv $sourceRoot $out

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      rm -rf $out/demo

      # Remove some broken manpages.
      rm -rf $out/man/ja*

      # Remove embedded freetype to avoid problems like
      # https://github.com/NixOS/nixpkgs/issues/57733
      find "$out" -name 'libfreetype.so*' -delete

      # Propagate the setJavaClassPath setup hook from the JDK so that
      # any package that depends on the JDK has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      cat <<EOF >> "$out/nix-support/setup-hook"
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF

      # We cannot use -exec since wrapProgram is a function but not a command.
      #
      # jspawnhelper is executed from JVM, so it doesn't need to wrap it, and it
      # breaks building OpenJDK (#114495).
      for bin in $( find "$out" -executable -type f -not -name jspawnhelper ); do
        if patchelf --print-interpreter "$bin" &> /dev/null; then
          wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
        fi
      done
    '';

    preFixup = ''
      find "$out" -name libfontmanager.so -exec \
        patchelf --add-needed libfontconfig.so {} \;
    '';

    # FIXME: use multiple outputs or return actual JRE package
    passthru.jre = result;

    passthru.home = result;

    meta = with lib; {
      license = licenses.gpl2Classpath;
      sourceProvenance = with sourceTypes; [
        binaryNativeCode
        binaryBytecode
      ];
      description = "AdoptOpenJDK, prebuilt OpenJDK binary";
      platforms = lib.mapAttrsToList (arch: _: arch + "-linux") sourcePerArch; # some inherit jre.meta.platforms
      maintainers = with lib.maintainers; [ taku0 ];
      inherit knownVulnerabilities;
      mainProgram = "java";
    };

  };
in
result
