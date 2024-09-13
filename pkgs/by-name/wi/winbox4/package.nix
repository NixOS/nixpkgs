{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  udev,
  libglvnd,
  libGL,
  zlib,
  freetype,
  fontconfig,
  libxkbcommon,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "winbox4";
  version = "4.0beta6";

  src = fetchzip {
    stripRoot = false;
    url = "https://download.mikrotik.com/routeros/winbox/${version}/WinBox_Linux.zip";
    hash = "sha256-kG18xkGRgApYObhmMKRfV33KOfOz9nMqX1GoE+zOT6w=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs =
    [
      udev
      libglvnd
      libGL
      zlib
      freetype
      fontconfig
      libxkbcommon
    ]
    ++ (with xorg; [
      libX11
      libXcursor
      libXrandr
      libxcb
      xcbutilwm
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
    ]);

  postInstall = ''
    mkdir -p $out/bin
    cp WinBox $out/bin/winbox4

    dimensions='512x512'
    mkdir -p $out/share/icons/hicolor/$dimensions/apps
    cp assets/img/winbox.png $out/share/icons/hicolor/$dimensions/apps/${meta.mainProgram}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = meta.mainProgram;
      exec = meta.mainProgram;
      icon = meta.mainProgram;
      desktopName = "Winbox4";
      genericName = "Winbox4";
      comment = meta.description;
      type = "Application";
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    mainProgram = "winbox4";
    description = "Graphical configuration utility for RouterOS-based devices";
    changelog = "https://download.mikrotik.com/routeros/winbox/${version}/CHANGELOG";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ sochotnicky ];
  };
}
