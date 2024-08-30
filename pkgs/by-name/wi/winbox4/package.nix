{
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  fontconfig,
  freetype,
  lib,
  libGL,
  libxkbcommon,
  makeDesktopItem,
  stdenvNoCC,
  unzip,
  xorg,
  zlib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "winbox";
  version = "4.0beta9";

  src = fetchurl {
    name = "WinBox_Linux-${finalAttrs.version}.zip";
    url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/WinBox_Linux.zip";
    hash = "sha256-129ejj3WxYx5kQTy6EOLtBolhx076yMVb5ymkAoXrwc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    unzip
  ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    libxkbcommon
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 "assets/img/winbox.png" "$out/share/pixmaps/winbox.png"
    install -Dm755 "WinBox" $out/bin/WinBox

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winbox";
      desktopName = "Winbox";
      comment = "GUI administration for Mikrotik RouterOS";
      exec = "WinBox";
      icon = "winbox";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Graphical configuration utility for RouterOS-based devices";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    changelog = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/CHANGELOG";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "WinBox";
    maintainers = with lib.maintainers; [ Scrumplex yrd ];
  };
})
