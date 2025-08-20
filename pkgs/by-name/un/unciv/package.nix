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
  libXxf86vm,
}:
let
  version = "4.14.9";

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
      libXxf86vm
    ]
  );

in
stdenv.mkDerivation rec {
  pname = "unciv";
  inherit version;

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-CmdQ4gEOu9U2e9Wk94uRCRq3OAEuncCAkV+ut4Chy9Q=";
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

  meta = with lib; {
    description = "Open-source Android/Desktop remake of Civ V";
    mainProgram = "unciv";
    homepage = "https://github.com/yairm210/Unciv";
    maintainers = with maintainers; [ tex ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
