{ lib
, fetchurl
, stdenvNoCC
, runtimeShell
, copyDesktopItems
, makeDesktopItem
, wineWowPackages
}:

let
  icon = fetchurl {
    name = "synthesia.png";
    url = "https://cdn.synthesia.app/images/headerIcon.png";
    hash = "sha256-M9cQqHwwjko5pchdNtIMjYwd4joIvBphAYnpw73qYzM=";
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "synthesia";
  version = "10.9";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Synthesia";
      comment = meta.description;
      exec = pname;
      icon = pname;
      categories = [ "Game" "Audio" ];
      startupWMClass = "synthesia.exe";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wineWowPackages.stable
  ];

  src = fetchurl {
    url = "https://cdn.synthesia.app/files/Synthesia-${version}-installer.exe";
    hash = "sha256-BFTsbesfMqxY1731ss6S0w8BcUaoqjVrr62VeU1BfrU=";
  };

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cat <<'EOF' > $out/bin/${pname}
    #!${runtimeShell}
    export PATH=${wineWowPackages.stable}/bin:$PATH
    export WINEARCH=win64
    export WINEPREFIX="''${SYNTHESIA_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/${pname}"}/wine"
    export WINEDLLOVERRIDES="mscoree=" # disable mono
    if [ ! -d "$WINEPREFIX" ] ; then
      mkdir -p "$WINEPREFIX"
      wine ${src} /S
    fi
    wine "$WINEPREFIX/drive_c/Program Files (x86)/Synthesia/Synthesia.exe"
    EOF
    chmod +x $out/bin/${pname}
    install -Dm644 ${icon} $out/share/icons/hicolor/48x48/apps/${pname}.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "A fun way to learn how to play the piano";
    homepage = "https://synthesiagame.com/";
    downloadPage = "https://synthesiagame.com/download";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ners ];
    platforms = wineWowPackages.stable.meta.platforms;
  };
}
