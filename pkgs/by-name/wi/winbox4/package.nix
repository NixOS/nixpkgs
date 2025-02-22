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
  makeWrapper,
  stdenvNoCC,
  unzip,
  undmg,
  writeShellApplication,
  xorg,
  zlib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "winbox";
  version = "4.0beta16";

  src =
    if stdenvNoCC.isDarwin then
      fetchurl {
        name = "WinBox-${finalAttrs.version}.dmg";
        url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/WinBox.dmg";
        hash = "sha256-ZxvuEVx9BmFukPMEPKeqXQNW38ExSpnRcSuHdw6j+CI=";
      }
    else
      fetchurl {
        name = "WinBox_Linux-${finalAttrs.version}.zip";
        url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/WinBox_Linux.zip";
        hash = "sha256-RZpsKew3BaId6+tcwUV6fniUpCH4wIP9ab6P5oE7OAk=";
      };

  sourceRoot = ".";

  nativeBuildInputs =
    if stdenvNoCC.isDarwin then
      [
        undmg
      ]
    else
      [
        autoPatchelfHook
        copyDesktopItems
        # makeBinaryWrapper does not support --run
        makeWrapper
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

  installPhase =
    if stdenvNoCC.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/{bin,Applications}
        cp -R "WinBox.app" "$out/Applications/WinBox.app"
        ln -s "$out/Applications/WinBox.app/Contents/MacOS/WinBox" "$out/bin/WinBox"

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -Dm644 "assets/img/winbox.png" "$out/share/pixmaps/winbox.png"
        install -Dm755 "WinBox" "$out/bin/WinBox"

        wrapProgram "$out/bin/WinBox" --run "${lib.getExe finalAttrs.migrationScript}"

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

  migrationScript = writeShellApplication {
    name = "winbox-migrate";
    text = ''
      XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}
      targetFile="$XDG_DATA_HOME/MikroTik/WinBox/Addresses.cdb"

      if [ -f "$targetFile" ]; then
        echo "NixOS: WinBox 4 data already present at $(dirname "$targetFile"). Skipping automatic migration."
        exit 0
      fi

      # cover both wine prefix variants
      # latter was used until https://github.com/NixOS/nixpkgs/pull/329626 was merged on 2024/07/24
      winePrefixes=(
        "''${WINEPREFIX:-$HOME/.wine}"
        "''${WINBOX_HOME:-$XDG_DATA_HOME/winbox}/wine"
      )
      sourceFilePathSuffix="drive_c/users/$USER/AppData/Roaming/Mikrotik/Winbox/Addresses.cdb"
      selectedSourceFile=""

      for prefix in "''${winePrefixes[@]}"
      do
        echo "NixOS: Probing WinBox 3 data path at $prefix..."
        if [ -f "$prefix/$sourceFilePathSuffix" ]; then
          selectedSourceFile="$prefix/$sourceFilePathSuffix"
          break
        fi
      done

      if [ -z "$selectedSourceFile" ]; then
        echo "NixOS: WinBox 3 data not found. Skipping automatic migration."
        exit 0
      fi

      echo "NixOS: Automatically migrating WinBox 3 data..."
      install -Dvm644 "$selectedSourceFile" "$targetFile"
    '';
  };

  meta = {
    description = "Graphical configuration utility for RouterOS-based devices";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    changelog = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/CHANGELOG";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "WinBox";
    maintainers = with lib.maintainers; [
      Scrumplex
      yrd
      savalet
    ];
  };
})
