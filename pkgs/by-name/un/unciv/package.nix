{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  jdk21,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  jre,
  libGL,
  libpulseaudio,
  libxxf86vm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unciv";
  version = "4.20.7";

  src = fetchFromGitHub {
    owner = "yairm210";
    repo = "Unciv";
    tag = finalAttrs.version;
    hash = "sha256-xiOPdiNlDfG288L2TXs/fp84gnB92pWGOg79oZuJ/Lo=";
  };

  nativeBuildInputs = [
    gradle
    jdk21
    copyDesktopItems
    makeWrapper
  ];

  env.JAVA_HOME = jdk21;

  gradleBuildTask = ":desktop:dist";

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unciv $out/bin
    cp desktop/build/libs/Unciv.jar $out/share/unciv/

    install -Dm444 "extraImages/Icons/Unciv icon v6.png" "$out/share/icons/hicolor/512x512/apps/unciv.png"

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications/Unciv.app/Contents/MacOS
      makeWrapper ${jre}/bin/java "$out/Applications/Unciv.app/Contents/MacOS/Unciv" \
        --prefix LD_LIBRARY_PATH : "${finalAttrs.passthru.libraries}" \
        --add-flags "-jar $out/share/unciv/Unciv.jar" \
        --append-flags '--data-dir=$HOME/.local/share/unciv'

      ln -s "$out/Applications/Unciv.app/Contents/MacOS/Unciv" "$out/bin/unciv"

      CP="$out/Applications/Unciv.app/Contents"
      mkdir -p "$CP/Resources"
      cp "extraImages/Icons/Unciv icon v6.png" "$CP/Resources/Unciv.png"

      substitute "${./info.plist}" "$CP/Info.plist" \
        --replace-fail "@version@" "${finalAttrs.version}"
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapper ${jre}/bin/java $out/bin/unciv \
        --prefix LD_LIBRARY_PATH : "${finalAttrs.passthru.libraries}" \
        --add-flags "-jar $out/share/unciv/Unciv.jar" \
        --append-flags '--data-dir=$HOME/.local/share/unciv'
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "unciv";
      exec = "unciv";
      comment = "An open-source Android/Desktop remake of Civ V";
      desktopName = "Unciv";
      icon = "unciv";
      categories = [ "Game" ];
    })
  ];

  passthru = {
    libraries = lib.makeLibraryPath (
      [
        libGL
        libpulseaudio
      ]
      ++ lib.optional stdenv.hostPlatform.isLinux libxxf86vm
    );
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source Android/Desktop remake of Civ V";
    mainProgram = "unciv";
    homepage = "https://github.com/yairm210/Unciv";
    maintainers = with lib.maintainers; [
      iedame
      philocalyst
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
  };
})
