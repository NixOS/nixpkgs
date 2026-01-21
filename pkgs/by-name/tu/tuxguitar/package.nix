{
  lib,
  stdenv,
  fetchFromGitHub,
  maven,
  swt,
  jdk,
  jre,
  makeBinaryWrapper,
  pkg-config,
  alsa-lib,
  jack2,
  fluidsynth,
  libpulseaudio,
  lilv,
  suil,
  qt5,
  which,
  wrapGAppsHook3,
  nixosTests,
  # Darwin frameworks - imported directly, only on Darwin
  AudioUnit ? null,
  CoreAudio ? null,
  CoreFoundation ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxguitar";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "helge17";
    repo = "tuxguitar";
    tag = finalAttrs.version;
    hash = "sha256-USdYj8ebosXkiZpDqyN5J+g1kjyWm225iQlx/szXmLA=";
  };

  patches = [
    ./fix-include.patch
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    maven
    jdk
    pkg-config
    fluidsynth.dev
    lilv.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    alsa-lib.dev
    jack2.dev
    libpulseaudio.dev
    suil
    qt5.qtbase.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    stdenv.cc
  ];

  buildInputs = [
    swt
    fluidsynth
    lilv
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    jack2
    libpulseaudio
    suil
    qt5.qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    AudioUnit
    CoreAudio
    CoreFoundation
  ];

  dontWrapQtApps = true;

  dontWrapGApps = true;

  # Build with offline mode using pre-fetched dependencies
  buildPhase = ''
    runHook preBuild

    # Create a writable repository
    mkdir -p .m2/repository
    cp -r ${finalAttrs.finalPackage.mavenDeps}/* .m2/repository/
    chmod -R +w .m2/repository

    # Copy SWT jar to a fixed location to avoid path dependencies
    cp ${swt}/jars/swt.jar swt-4.36.jar

    # Install SWT jar into our mutable repository
    mvn install:install-file \
      -Dfile=$(pwd)/swt-4.36.jar \
      -DgroupId=org.eclipse.swt \
      -DartifactId=${finalAttrs.finalPackage.passthru.swtArtifactId} \
      -Dpackaging=jar \
      -Dversion=4.36 \
      -Dmaven.repo.local=$(pwd)/.m2/repository

    mvn package -e -f ${finalAttrs.finalPackage.buildScript} -P native-modules \
      -o -Dmaven.test.skip=true \
      -Dmaven.repo.local=$(pwd)/.m2/repository

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Find the built tuxguitar directory (it's in the subdirectory where we ran maven)
    cd ${finalAttrs.finalPackage.passthru.buildDir}
  ''
  # macOS: The build creates tuxguitar-VERSION-macosx-swt-cocoa.app directly
  # This directory name already ends with .app and IS the app bundle
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r target/tuxguitar-*-macosx-swt-cocoa.app $out/Applications/TuxGuitar.app

    # Fix the launch script to use the Nix JRE instead of bundled JRE
    substituteInPlace $out/Applications/TuxGuitar.app/Contents/MacOS/tuxguitar.sh \
      --replace-fail 'JAVA="./jre/bin/java"' 'JAVA="${jre}/bin/java"'

    # Ensure the main executable has execute permissions
    chmod +x $out/Applications/TuxGuitar.app/Contents/MacOS/tuxguitar.sh

    # Symlink doesn't work. We have to create a wrapper script instead
    mkdir -p $out/bin
    cat > $out/bin/tuxguitar <<EOF
    #!/bin/sh
    exec "$out/Applications/TuxGuitar.app/Contents/MacOS/tuxguitar.sh" "\$@"
    EOF
    chmod +x $out/bin/tuxguitar
  ''
  # Linux: Install traditional layout
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    TUXGUITAR_DIR=$(ls -d target/tuxguitar-* | head -n 1)
    mkdir -p $out/{bin,lib}
    cp -r $TUXGUITAR_DIR $out/lib/tuxguitar
    ln -s $out/lib/tuxguitar/tuxguitar.sh $out/bin/tuxguitar

    # Selectively symlink share directories, but filter templates
    mkdir -p $out/share
    for dir in $out/lib/tuxguitar/share/*; do
      if [ "$(basename "$dir")" != "templates" ]; then
        ln -s "$dir" $out/share/
      fi
    done

    # Only install templates that should appear in "Create New" menu (not localized defaults)
    mkdir -p $out/share/templates
    cp $out/lib/tuxguitar/share/templates/template-1.tg $out/share/templates/
    cp $out/lib/tuxguitar/share/templates/template-2.tg $out/share/templates/
    cp $out/lib/tuxguitar/share/templates/templates.xml $out/share/templates/
  ''
  + ''

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/tuxguitar ${lib.concatStringsSep " " finalAttrs.finalPackage.passthru.wrapperArgs}
  '';

  passthru = {
    tests.nixos = nixosTests.tuxguitar;
    swtArtifactId =
      "org.eclipse.swt." + (if stdenv.hostPlatform.isDarwin then "cocoa.macosx" else "gtk.linux");

    buildDir =
      "desktop/build-scripts/tuxguitar-"
      + (if stdenv.hostPlatform.isDarwin then "macosx-swt-cocoa" else "linux-swt");
    buildScript = finalAttrs.finalPackage.passthru.buildDir + "/pom.xml";
    ldLibVar = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    classpath = [
      "${swt}/jars/swt.jar"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "$out/lib/tuxguitar.jar"
      "$out/lib/itext.jar"
    ];
    libraryPath = [
      "$out/lib"
      fluidsynth
      lilv
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      swt
      alsa-lib
      jack2
      libpulseaudio
    ];
    wrapperPaths = [
      jre
      which
    ];
    wrapperArgs = [
      "\${gappsWrapperArgs[@]}"
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath finalAttrs.finalPackage.passthru.wrapperPaths)
      "--prefix"
      finalAttrs.finalPackage.passthru.ldLibVar
      ":"
      (lib.makeLibraryPath finalAttrs.finalPackage.passthru.libraryPath)
      "--prefix"
      "CLASSPATH"
      ":"
      (lib.concatStringsSep ":" finalAttrs.finalPackage.passthru.classpath)
    ];

    # Fetch Maven dependencies in a fixed-output derivation
    # We fetch dependencies WITHOUT the native-modules profile to keep it deterministic
    mavenDeps = stdenv.mkDerivation {
      name = "${finalAttrs.finalPackage.pname}-${finalAttrs.finalPackage.version}-maven-deps";
      inherit (finalAttrs.finalPackage) src patches;
      nativeBuildInputs = [
        maven
        jdk
      ];

      buildPhase = ''
        runHook preBuild

        # Use a temporary local repository
        mkdir -p .m2/repository

        # Copy SWT jar to a fixed location to avoid path dependencies
        cp ${swt}/jars/swt.jar swt-4.36.jar

        # Install SWT jar from fixed location
        mvn install:install-file \
          -Dfile=$(pwd)/swt-4.36.jar \
          -DgroupId=org.eclipse.swt \
          -DartifactId=${finalAttrs.finalPackage.passthru.swtArtifactId} \
          -Dpackaging=jar \
          -Dversion=4.36 \
          -Dmaven.repo.local=$(pwd)/.m2/repository

        # Download dependencies WITH native-modules profile to get all deps
        mvn dependency:go-offline -f ${finalAttrs.finalPackage.passthru.buildScript} -P native-modules \
          -Dmaven.repo.local=$(pwd)/.m2/repository

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        # Copy to output, removing timestamps and non-deterministic files
        mkdir -p $out
        cp -r .m2/repository/* $out/

        # Remove swt from the output to avoid hash invalidation
        rm -rf $out/org/eclipse/swt

        # Remove resolver status files that contain timestamps
        find $out -name "_remote.repositories" -delete
        find $out -name "*.lastUpdated" -delete
        find $out -name "resolver-status.properties" -delete
        find $out -type f -name "maven-metadata-*.xml" -delete

        # Reset timestamps for determinism
        find $out -exec touch -t 197001010000 {} +

        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-3KKwaHYDxEN3m2obuijzYrWEPGcbjI6z+eTmtiIl0Ic=";
    };
  };

  meta = {
    description = "Multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = "https://github.com/helge17/tuxguitar";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      ardumont
      mio
    ];
    platforms = builtins.attrNames swt.passthru.srcMetadataByPlatform;
    mainProgram = "tuxguitar";
  };
})
