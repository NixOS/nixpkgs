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
}:

let
  swtArtifactId =
    "org.eclipse.swt." + (if stdenv.hostPlatform.isDarwin then "cocoa.macosx" else "gtk.linux");
  buildDir =
    "desktop/build-scripts/tuxguitar-"
    + (if stdenv.hostPlatform.isDarwin then "macosx-swt-cocoa" else "linux-swt");
  buildScript = "${buildDir}/pom.xml";
  mvnParams = lib.escapeShellArgs [
    "-f"
    buildScript
    "-P"
    "native-modules"
    "-Dmaven.test.skip=true"
  ];
in
maven.buildMavenPackage rec {
  pname = "tuxguitar";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "helge17";
    repo = "tuxguitar";
    tag = version;
    hash = "sha256-USdYj8ebosXkiZpDqyN5J+g1kjyWm225iQlx/szXmLA=";
  };

  patches = [
    ./fix-include.patch
  ];

  buildOffline = true;

  mvnJdk = jdk;

  mvnHash = (
    passthru.mvnHashByPlatform.${stdenv.system}
      or (lib.warn "Missing mvnHash for ${stdenv.system}, using lib.fakeHash" lib.fakeHash)
  );

  mvnParameters = mvnParams;
  mvnDepsParameters = mvnParams;

  mvnFetchExtraArgs = {
    dontWrapQtApps = true;
    dontWrapGApps = true;
    preBuild = ''
      mkdir -p $out/.m2
      mvn install:install-file \
        -Dfile=${swt}/jars/swt.jar \
        -DgroupId=org.eclipse.swt \
        -DartifactId=${swtArtifactId} \
        -Dpackaging=jar \
        -Dversion=4.36 \
        -Dmaven.repo.local=$out/.m2
    '';
    postInstall = ''
      rm -rf $out/.m2/repository/org/eclipse/swt
      find $out -type f -name "maven-metadata-*.xml" -delete
      find $out -exec touch -t 197001010000 {} +
    '';
  };

  afterDepsSetup = ''
    mvn install:install-file \
      -Dfile=${swt}/jars/swt.jar \
      -DgroupId=org.eclipse.swt \
      -DartifactId=${swtArtifactId} \
      -Dpackaging=jar \
      -Dversion=4.36 \
      -Dmaven.repo.local=$mvnDeps/.m2
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
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
  ];

  dontWrapQtApps = true;

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    # Find the built tuxguitar directory (it's in the subdirectory where we ran maven)
    cd ${buildDir}
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
    wrapProgram $out/bin/tuxguitar ${lib.concatStringsSep " " passthru.wrapperArgs}
  '';

  passthru = rec {
    tests.nixos = nixosTests.tuxguitar;
    inherit swtArtifactId buildDir buildScript;
    # FIXME: Makes hash stable across platforms and convert to a single hash.
    mvnHashByPlatform = {
      "x86_64-linux" = "sha256-7UDFGuOMERvY74mkneusJyuAHfF3U6b4qV4MPHGQYdM=";
      "aarch64-linux" = "sha256-7UDFGuOMERvY74mkneusJyuAHfF3U6b4qV4MPHGQYdM=";
      "aarch64-darwin" = "sha256-lfO2YH+yKZWzh3MeQ7baESGmmW7zPdTLs8CjZ/FtLu0";
    };
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
      (lib.makeBinPath wrapperPaths)
      "--prefix"
      ldLibVar
      ":"
      (lib.makeLibraryPath libraryPath)
      "--prefix"
      "CLASSPATH"
      ":"
      (lib.concatStringsSep ":" classpath)
    ];
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
    platforms = builtins.attrNames passthru.mvnHashByPlatform;
    mainProgram = "tuxguitar";
  };
}
