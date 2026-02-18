{
  stdenv,
  lib,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  jre,
  libGL,
  libpulseaudio,
  libxxf86vm,
  nix-update-script,
}:
let
  version = "4.19.12";

  desktopItem = makeDesktopItem {
    name = "unciv";
    exec = "unciv";
    comment = "An open-source Android/Desktop remake of Civ V";
    desktopName = "Unciv";
    icon = "unciv";
    categories = [ "Game" ];
  };

  desktopIcon = fetchurl {
    url = "https://github.com/yairm210/Unciv/blob/${version}/extraImages/Icons/Unciv%20icon%20v6.png?raw=true";
    hash = "sha256-Zuz+HGfxjGviGBKTiHdIFXF8UMRLEIfM8f+LIB/xonk=";
  };

  envLibPath = lib.makeLibraryPath (
    lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      libpulseaudio
      libxxf86vm
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "unciv";
  inherit version;

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-rswc0ssIAF4AAGiGlGu2ls2ZG1oPzjJnd5j5CQb+Hsc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/unciv \
      --prefix LD_LIBRARY_PATH : "${envLibPath}" \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar ${src}"

    install -Dm444 ${desktopIcon} $out/share/icons/hicolor/512x512/apps/unciv.png

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source Android/Desktop remake of Civ V";
    mainProgram = "unciv";
    homepage = "https://github.com/yairm210/Unciv";
    maintainers = with lib.maintainers; [ iedame ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
  };
}
