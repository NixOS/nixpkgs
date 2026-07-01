{
  lib,
  stdenvNoCC,
  fetchurl,
  jdk8,
  makeWrapper,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xadrian";
  version = "1.5.1";

  # The source release (tag xadrian-1.5.1) cannot be built: it depends on
  # de.ailis:oneinstance, which was only published to nexus.ailis.de (now
  # offline) and is not on Maven Central. The upstream release instead ships
  # prebuilt, self-contained artifacts, which we repackage here.
  src =
    if stdenvNoCC.hostPlatform.isDarwin then
      fetchurl {
        url = "https://github.com/kayahr/xadrian/releases/download/xadrian-${finalAttrs.version}/xadrian-${finalAttrs.version}-macosx.zip";
        hash = "sha256-nCkhlC/nrTxCMd2jO+avkFlXD98a+rFvD6uoCfcZ3PU=";
      }
    else
      fetchurl {
        url = "https://github.com/kayahr/xadrian/releases/download/xadrian-${finalAttrs.version}/xadrian-${finalAttrs.version}-unix.tar.bz2";
        hash = "sha256-MVWvYbI9V9s0CbmM6DXmWZEu0kdn9ZIpNcnJZhkDsjU=";
      };

  sourceRoot = if stdenvNoCC.hostPlatform.isDarwin then "." else "xadrian-${finalAttrs.version}";

  __structuredAttrs = true;
  strictDeps = true;

  # Xadrian must run on a Java 8 runtime: it uses javax.xml.bind (JAXB), which
  # was bundled in the JDK only through Java 8 and removed in Java 11+.
  nativeBuildInputs = [
    unzip
  ]
  # A macOS .app's CFBundleExecutable must be a real binary, so use
  # makeBinaryWrapper on Darwin; makeWrapper's shell script is fine elsewhere.
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ makeBinaryWrapper ]
  ++ lib.optionals (!stdenvNoCC.hostPlatform.isDarwin) [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = lib.optionals (!stdenvNoCC.hostPlatform.isDarwin) [
    (makeDesktopItem {
      name = "xadrian";
      desktopName = "Xadrian";
      exec = "xadrian";
      icon = "xadrian";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      startupWMClass = "Xadrian";
    })
  ];

  installPhase = ''
    runHook preInstall
  ''
  + (
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        cp -R Xadrian.app $out/Applications/
        appdir=$out/Applications/Xadrian.app
        chmod -R u+w "$appdir"

        # The bundled JavaApplicationStub is Apple's long-removed Java 6
        # launcher (no arm64, broken on modern macOS); replace it with a JRE
        # wrapper so the .app actually launches.
        rm -f "$appdir/Contents/MacOS/JavaApplicationStub"
        makeWrapper ${jdk8}/bin/java "$appdir/Contents/MacOS/JavaApplicationStub" \
          --add-flags "-jar $appdir/Contents/Resources/Java/xadrian.jar"

        makeWrapper ${jdk8}/bin/java $out/bin/xadrian \
          --add-flags "-jar $appdir/Contents/Resources/Java/xadrian.jar"
      ''
    else
      ''
        # Keep the jars co-located so xadrian.jar's relative Class-Path resolves.
        install -Dm644 -t $out/share/xadrian lib/*.jar

        # The application icon is embedded in the jar.
        unzip -p $out/share/xadrian/xadrian.jar de/ailis/xadrian/images/xadrian-64.png \
          > xadrian.png
        install -Dm644 xadrian.png $out/share/icons/hicolor/64x64/apps/xadrian.png

        makeWrapper ${jdk8}/bin/java $out/bin/xadrian \
          --add-flags "-jar $out/share/xadrian/xadrian.jar"
      ''
  )
  + ''
    runHook postInstall
  '';

  meta = {
    description = "Factory complex calculator for X3: Terran Conflict and X3: Albion Prelude";
    homepage = "https://github.com/kayahr/xadrian";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ FabricSoul ];
    mainProgram = "xadrian";
    platforms = jdk8.meta.platforms;
  };
})
