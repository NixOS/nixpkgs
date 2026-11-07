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
    (if stdenv.hostPlatform.isDarwin then "native-modules,platform-macos-cocoa" else "native-modules")
    "-Dmaven.test.skip=true"
  ];
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
  # FIXME: Makes hash stable across platforms and convert to a single hash.
  mvnHashByPlatform = {
    "x86_64-linux" = "sha256-0eYUC6rThbERyF9viho8NUTwPkVBE/KUmhCiG3I5dt0=";
    "aarch64-linux" = "sha256-0eYUC6rThbERyF9viho8NUTwPkVBE/KUmhCiG3I5dt0=";
    "aarch64-darwin" = "sha256-GInIr2XG2852aDk1EaGdrgj7qDlioKVLdj8HrP2xgPc=";
  };
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
  version = "2.1.1";
in
maven.buildMavenPackage {
  pname = "tuxguitar";
  inherit version;

  src = fetchFromGitHub {
    owner = "helge17";
    repo = "tuxguitar";
    tag = version;
    hash = "sha256-Rwj81MNb4S7CqSfNE9BG2/MotDFQpoYl5WBuoYJCkbE=";
  };

  patches = [
    ./fix-include.patch
  ];

  buildOffline = true;

  mvnJdk = jdk;

  mvnHash = (
    mvnHashByPlatform.${stdenv.system}
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
        -Dversion=4.37 \
        -Dmaven.repo.local=$out/.m2
    '';
    postInstall = ''
      rm -rf $out/.m2/repository/org/eclipse/swt
      find $out -type f -name "maven-metadata-*.xml" -delete
    '';
  };

  afterDepsSetup = ''
    mvn install:install-file \
      -Dfile=${swt}/jars/swt.jar \
      -DgroupId=org.eclipse.swt \
      -DartifactId=${swtArtifactId} \
      -Dpackaging=jar \
      -Dversion=4.37 \
      -Dmaven.repo.local=$mvnDeps/.m2
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
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

    cd ${buildDir}
  ''
  # macOS: The build creates tuxguitar-VERSION-macosx-swt-cocoa.app directly
  # This directory name already ends with .app and IS the app bundle
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r target/tuxguitar-9.99-SNAPSHOT-macosx-swt-cocoa.app $out/Applications/TuxGuitar.app

    # Fix the launch script to use the Nix JRE instead of bundled JRE
    substituteInPlace $out/Applications/TuxGuitar.app/Contents/MacOS/tuxguitar.sh \
      --replace-fail 'JAVA="./jre/bin/java"' 'JAVA="${jre}/bin/java"'

    # Ensure the main executable has execute permissions
    chmod +x $out/Applications/TuxGuitar.app/Contents/MacOS/tuxguitar.sh

    # Symlink doesn't work. We have to create a wrapper script instead
    mkdir -p $out/bin
    makeWrapper "$out/Applications/TuxGuitar.app/Contents/MacOS/tuxguitar.sh" \
      "$out/bin/tuxguitar"
  ''
  # Linux: Install traditional layout
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    TUXGUITAR_DIR=target/tuxguitar-9.99-SNAPSHOT-linux-swt
    mkdir -p $out/{bin,lib}
    cp -r $TUXGUITAR_DIR $out/lib/tuxguitar
    ln -s $out/lib/tuxguitar/tuxguitar.sh $out/bin/tuxguitar

    mkdir -p $out/share
    ln -s $out/lib/tuxguitar/share/{applications,man,metainfo,mime,pixmaps} -t $out/share/

    # See https://github.com/helge17/tuxguitar/issues/961
    mkdir -p $out/share/templates/.source
    ln -s $out/lib/tuxguitar/share/templates/ $out/share/templates/.source/tuxguitar
    cp ../common-resources/common-linux/share/templates/TuxGuitar.desktop $out/share/templates/
  ''
  + ''

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/tuxguitar ${lib.concatStringsSep " " wrapperArgs}
  '';

  passthru = {
    tests.nixos = nixosTests.tuxguitar;
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
    platforms = builtins.attrNames mvnHashByPlatform;
    mainProgram = "tuxguitar";
  };
}
