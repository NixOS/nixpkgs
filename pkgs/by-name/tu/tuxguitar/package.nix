{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  maven,
  swt,
  jdk,
  jre,
  makeWrapper,
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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "helge17";
    repo = "tuxguitar";
    tag = finalAttrs.version;
    hash = "sha256-Kk6TQ2t4exVeRyxrCqpdddJE7BfZRlW+B/lUJ+SPPd8=";
  };

  patches = [
    ./fix-include.patch
    # https://github.com/helge17/tuxguitar/pull/937
    (fetchpatch {
      url = "https://github.com/helge17/tuxguitar/commit/e4ff89f19332b1b881038273afd78e1c45354565.patch";
      hash = "sha256-Iek02qK0xxrZcTmcYVpC8hv3r8/5jzdPLvY7OasukJg=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
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

    mvn package -e -f ${finalAttrs.finalPackage.buildScript} -P native-modules \
      -o -Dmaven.test.skip=true \
      -Dmaven.repo.local=${finalAttrs.finalPackage.mavenDeps}/repository

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
        cp -r .m2/repository $out/

        # Remove resolver status files that contain timestamps
        find $out/repository -name "_remote.repositories" -delete
        find $out/repository -name "*.lastUpdated" -delete
        find $out/repository -name "resolver-status.properties" -delete
        find $out/repository -type f -name "maven-metadata-*.xml" -delete

        # Reset timestamps for determinism
        find $out -exec touch -t 197001010000 {} +

        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = finalAttrs.finalPackage.passthru.mavenDepsHashes.${stdenv.hostPlatform.system};
    };
    mavenDepsHashes = {
      x86_64-linux = "sha256-p0YVx0ZvFaJ9kWu9oIP+uxk4AWzcTAUgBPMsmgounkQ=";
      aarch64-linux = "sha256-gXSUYNv7BheIgpbY3cXKj+isaMzuS+Gf4cKBzXuOVZw=";
      aarch64-darwin = "sha256-bhLNcpenc6VNrMbzijX7WxaK/8Gi8EAGK6ibH9QKpVI=";
    };
  };

  meta = {
    description = "Multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = "https://github.com/helge17/tuxguitar";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ardumont ];
    platforms = builtins.attrNames finalAttrs.finalPackage.passthru.mavenDepsHashes;
    mainProgram = "tuxguitar";
  };
})
